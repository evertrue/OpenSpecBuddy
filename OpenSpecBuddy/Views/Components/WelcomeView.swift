//
//  WelcomeView.swift
//  OpenSpecBuddy
//

import SwiftUI
import UniformTypeIdentifiers

struct WelcomeView: View {
    @Environment(AppViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack(spacing: 24) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            Text("OpenSpec Buddy")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text("Open an OpenSpec project to browse specs, changes, and archives.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 400)

            Button(action: { viewModel.showDirectoryPicker() }) {
                Label("Open Directory", systemImage: "folder")
                    .frame(minWidth: 150)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .keyboardShortcut("o", modifiers: .command)

            if !viewModel.recentDirectories.isEmpty {
                Divider()
                    .frame(width: 300)
                    .padding(.vertical, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    ForEach(viewModel.recentDirectories.prefix(5)) { recent in
                        RecentDirectoryRow(recent: recent)
                    }
                }
                .frame(width: 300)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.callout)
                    .foregroundStyle(.red)
                    .padding()
                    .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    }
}

struct RecentDirectoryRow: View {
    let recent: RecentDirectory
    @Environment(AppViewModel.self) private var viewModel

    var body: some View {
        Button(action: { viewModel.openRecentDirectory(recent) }) {
            HStack {
                Image(systemName: "folder")
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 2) {
                    Text(recent.name)
                        .lineLimit(1)
                    Text(recent.path)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 6))
    }
}
