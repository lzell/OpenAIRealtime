//
//  macOSRealtimeApp.swift
//  macOSRealtime
//
//  Created by Lou Zell on 6/10/25.
//

import SwiftUI

@main
struct macOSRealtimeApp: App {
    @State var viewModel = ContentViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
