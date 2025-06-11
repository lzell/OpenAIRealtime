//
//  RealtimeManager.swift
//  ClientTester
//
//  Created by Lou Zell on 5/26/25.
//

import AIProxy
import AVFoundation

var sharedRealtimeManager = RealtimeManager()

@RealtimeActor
final class RealtimeManager {
    private var realtimeSession: OpenAIRealtimeSession?
    private var audioController: AudioController?

    nonisolated init() {}

    func startConversation(
        doneInitializing: @escaping () -> Void
    ) async throws {
        let openAIService = AIProxyIntegration.openAIService
        /* Uncomment for BYOK use cases */
        // let openAIService = AIProxy.openAIDirectService(
        //     unprotectedAPIKey: "your-openai-key"
        // )

        /* Uncomment to protect your connection through AIProxy */
        // let openAIService = AIProxy.openAIService(
        //     partialKey: "partial-key-from-your-developer-dashboard",
        //     serviceURL: "service-url-from-your-developer-dashboard"
        // )

        // Set to false if you want your user to speak first
        let aiSpeaksFirst = true

        let audioController = try await AudioController(modes: [.playback, .record])
        let micStream = try audioController.micStream()

        // Start the realtime session:
        let configuration = OpenAIRealtimeSessionConfiguration(
            inputAudioFormat: .pcm16,
            inputAudioTranscription: .init(model: "whisper-1"),
            instructions: "You are a helpful assistant",
            maxResponseOutputTokens: .int(4096),
            modalities: [.audio, .text],
            outputAudioFormat: .pcm16,
            temperature: 0.7,
            turnDetection: .init(
                type: .semanticVAD(eagerness: .high)
            ),
            voice: "alloy"
        )

        let realtimeSession = try await openAIService.realtimeSession(
            model: "gpt-4o-realtime-preview-2024-12-17", // "gpt-4o-realtime-preview-2025-06-03",
            configuration: configuration,
            logLevel: .debug
        )

        // Send audio from the microphone to OpenAI once OpenAI is ready for it:
        var isOpenAIReadyForAudio = false
        Task {
            for await buffer in micStream {
                if isOpenAIReadyForAudio, let base64Audio = AIProxy.base64EncodeAudioPCMBuffer(from: buffer) {
                    await realtimeSession.sendMessage(
                        OpenAIRealtimeInputAudioBufferAppend(audio: base64Audio)
                    )
                }
            }
        }

        // Listen for messages from OpenAI:
        Task {
            for await message in realtimeSession.receiver {
                switch message {
                case .error(_):
                    realtimeSession.disconnect()
                case .sessionUpdated:
                    if aiSpeaksFirst {
                        await realtimeSession.sendMessage(OpenAIRealtimeResponseCreate())
                    } else {
                        isOpenAIReadyForAudio = true
                    }
                case .responseAudioDelta(let base64String):
                    audioController.playPCM16Audio(base64String: base64String)
                case .inputAudioBufferSpeechStarted:
                    audioController.interruptPlayback()
                case .responseCreated:
                    doneInitializing()
                    isOpenAIReadyForAudio = true
                default:
                    break
                }
            }
        }

        self.realtimeSession = realtimeSession
        self.audioController = audioController
    }

    func stopConversation() {
        self.audioController?.stop()
        self.realtimeSession?.disconnect()
        self.audioController = nil
        self.realtimeSession = nil
    }

    private func buildInstructions() -> String {
        let additions = "The question is about statistics."
        return """
        You are a math assistant.
        Walk me through how to solve a problem using the binomial theorem.
        Describe what it is good for.
        Be professional and polite.
        Do not start with 'certainly'.
        \(additions)
        """
    }
}
