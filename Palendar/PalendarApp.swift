//
//  PalendarApp.swift
//  Palendar
//
//  Created by David Auld on 2024-09-09.
//

import SwiftUI

@main
struct PalendarApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(viewModel: ContentViewModel(palService: PalService()))
        }
    }
}
