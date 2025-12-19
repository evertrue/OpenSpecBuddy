//
//  OpenSpecBuddyApp.swift
//  OpenSpecBuddy
//

import SwiftUI
import OSLog

@main
struct OpenSpecBuddyApp: App {
    @State private var viewModel = AppViewModel()

    init() {
        Logger.app.info("OpenSpecBuddy launching")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
                .onAppear {
                    Logger.app.info("Main window appeared")
                }
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
