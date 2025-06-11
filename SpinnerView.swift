//
//  SpinnerView.swift
//  macOSRealtime
//
//  Created by Lou Zell on 6/10/25.
//

import SwiftUI

#if os(macOS)
import AppKit

struct SpinnerView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSProgressIndicator {
        let indicator = NSProgressIndicator()
        indicator.style = .spinning
        indicator.controlSize = .small
        indicator.contentFilters = [CIFilter(name: "CIColorInvert")!]
        indicator.startAnimation(nil)
        return indicator
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {}
}

#elseif os(watchOS)
struct SpinnerView: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(Color.white, lineWidth: 3)
            .frame(width: 20, height: 20)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}
#else

struct SpinnerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
#endif
