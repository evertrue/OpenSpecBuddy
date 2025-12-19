//
//  OpenSpecBuddyApp.swift
//  OpenSpecBuddy
//

import SwiftUI

@main
struct OpenSpecBuddyApp: App {
    @State private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open Directory...") {
                    viewModel.showDirectoryPicker()
                }
                .keyboardShortcut("o", modifiers: .command)
            }
        }
    }
}
