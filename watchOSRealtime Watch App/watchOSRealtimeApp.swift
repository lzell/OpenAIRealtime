//
//  watchOSRealtimeApp.swift
//  watchOSRealtime Watch App
//
//  Created by Lou Zell on 6/10/25.
//

import SwiftUI

@main
struct watchOSRealtime_Watch_AppApp: App {
    @State var viewModel = ContentViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
