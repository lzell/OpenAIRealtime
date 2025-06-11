//
//  iOSRealtimeApp.swift
//  iOSRealtime
//
//  Created by Lou Zell on 6/10/25.
//

import SwiftUI

@main
struct iOSRealtimeApp: App {
    @State var viewModel = ContentViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: self.viewModel)
        }
    }
}
