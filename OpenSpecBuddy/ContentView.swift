//
//  ContentView.swift
//  OpenSpecBuddy
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(AppViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        Group {
            if viewModel.hasDirectory {
                NavigationSplitView {
                    SidebarView()
                } detail: {
                    DetailView()
                }
                .navigationTitle(viewModel.currentDirectory?.displayName ?? "OpenSpec Buddy")
            } else {
                WelcomeView()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if viewModel.hasDirectory {
                    Button(action: {
                        Task {
                            await viewModel.refresh()
                        }
                    }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .keyboardShortcut("r", modifiers: .command)

                    Button(action: { viewModel.closeDirectory() }) {
                        Label("Close", systemImage: "xmark.circle")
                    }
                }

                Button(action: { viewModel.showDirectoryPicker() }) {
                    Label("Open", systemImage: "folder")
                }
                .keyboardShortcut("o", modifiers: .command)
            }
        }
        .fileImporter(
            isPresented: $viewModel.isFileImporterPresented,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    Task {
                        await viewModel.loadDirectory(url: url)
                    }
                }
            case .failure(let error):
                viewModel.setError("Failed to open directory: \(error.localizedDescription)")
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppViewModel())
}
