//
//  ContentView.swift
//  OpenAIRealtime
//
//  Created by Todd Hamilton on 6/10/25.
//

import SwiftUI
import Orb

struct ContentView: View {

    let viewModel: ContentViewModel

    var body: some View {
        ZStack {
            MeshView()
            VStack {
                Spacer()
                orbView()
                Spacer()
                VStack {
                    controlView()
                    captionView()
                }.padding()
            }
        }
    }

    private func orbView() -> some View {
        HStack {
            OrbView(configuration: viewModel.orbConfiguration)
                .frame(width: viewModel.orbDimension, height: viewModel.orbDimension)
                .shadow(color:.purple.opacity(isStarted ? 0.24 : 0), radius: 8, y:8)
                .scaleEffect(isStarted ? 1 : 0.5)
                .brightness(isStarted ? 0 : -1)
                .saturation(isStarted ? 1 : 0)
                .opacity(isStarted ? 1 : 0.75)
        }
    }

    private func controlView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: isStarted ? 4 : 28)
                .frame(width:56, height:56)
                .foregroundStyle(isStarted ? .black : .red)
                .scaleEffect(isStarted ? 0.65 : 1)

            if isStarting {
                SpinnerView()
            } else if isStopped {
                Image(systemName:"waveform")
                    .foregroundStyle(.white)
            }
        }
        #if os(iOS)
        .padding(8)
        .background(
            Circle()
                .fill(.ultraThickMaterial)
                .stroke(.separator.secondary, lineWidth: 1)
                .shadow(color:.black.opacity(0.14),radius: 4, y:3)
        )
        #endif
        .onTapGesture {
            withAnimation(.bouncy) {
                viewModel.realtimeState.userToggle()
            }
        }
    }

    private func captionView() -> some View {
        Text("Press to \(isStarted ? "stop" : "start") realtime")
            .foregroundStyle(.secondary)
            .font(.subheadline)
            .contentTransition(.numericText())
    }

    private var isStarted: Bool {
        viewModel.realtimeState == .started
    }

    private var isStarting: Bool {
        viewModel.realtimeState == .starting
    }

    private var isStopped: Bool {
        viewModel.realtimeState == .stopped
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
