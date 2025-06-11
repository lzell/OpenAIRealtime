//
//  BGView.swift
//  OpenAIRealtime
//
//  Created by Todd Hamilton on 3/11/25.
//

import SwiftUI

struct MeshView: View {
    var body: some View {
        MeshGradient(
            width: 2,
            height: 3,
            points: [
                [0, 0],[1, 0],
                [0, 0.25],[1, 0.25],
                [0, 1],[1, 1]
            ],
            colors: [
                .white,
                .white,
                .brown.opacity(0.14),
                .brown.opacity(0.14),
                .pink.opacity(0.27),
                .purple.opacity(0.25)
            ]
        )
        .ignoresSafeArea()

    }
}

#Preview {
    MeshView()
}
