//
//  ContentViewModel.swift
//  OpenAIRealtime
//
//  Created by Lou Zell on 6/10/25.
//

import SwiftUI
import Orb

@Observable
@MainActor
final class ContentViewModel {

    let orbConfiguration = OrbConfiguration(
        backgroundColors: [.purple, .blue, .pink],
        glowColor: .white,
        coreGlowIntensity: 1.2,
        showBackground: true,
        showWavyBlobs: true,
        showParticles: false,
        showGlowEffects: true,
        showShadow: false,
        speed: 8
    )

    var orbDimension: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.width / 2
        #elseif os(macOS)
        return 200
        #else
        return UIScreen.main.bounds.width / 2
        #endif
    }

    var realtimeState: RealtimeState = .stopped {
        willSet {
            switch newValue {
            case .starting:
                Task { await self.startRealtime() }
            case .started:
                break
            case .stopped:
                Task { await self.stopRealtime() }
            }
        }
    }

    private func startRealtime() async {
        do {
            try await sharedRealtimeManager.startConversation {
                Task { @MainActor in
                    if self.realtimeState == .starting {
                        withAnimation {
                            self.realtimeState = .started
                        }
                    }
                }
            }
        } catch {
            print("Could not start realtime: \(error.localizedDescription)")
        }
    }

    private func stopRealtime() async {
        await sharedRealtimeManager.stopConversation()
    }
}
