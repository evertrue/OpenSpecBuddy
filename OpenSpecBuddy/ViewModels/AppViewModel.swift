//
//  AppViewModel.swift
//  OpenSpecBuddy
//

import Foundation

@Observable
@MainActor
final class AppViewModel {
    private(set) var currentDirectory: OpenSpecDirectory?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var selectedItem: SidebarItem?
    var isFileImporterPresented = false

    let recentDirectoriesService = RecentDirectoriesService()
    private let scanner = DirectoryScanner()

    var hasDirectory: Bool {
        currentDirectory != nil
    }

    var recentDirectories: [RecentDirectory] {
        recentDirectoriesService.recentDirectories
    }

    func showDirectoryPicker() {
        isFileImporterPresented = true
    }

    func openRecentDirectory(_ recent: RecentDirectory) {
        guard let url = recentDirectoriesService.resolveBookmark(for: recent) else {
            errorMessage = "Could not access directory: \(recent.path)"
            return
        }

        let didStart = url.startAccessingSecurityScopedResource()
        defer {
            if didStart {
                url.stopAccessingSecurityScopedResource()
            }
        }

        Task {
            await loadDirectory(url: url)
        }
    }

    func loadDirectory(url: URL) async {
        isLoading = true
        errorMessage = nil
        selectedItem = nil

        do {
            let directory = try await scanner.scan(url: url)
            currentDirectory = directory
            recentDirectoriesService.addRecent(url: url, name: directory.displayName)
        } catch DirectoryScanner.ScanError.notAnOpenSpecDirectory {
            errorMessage = "Not an OpenSpec directory. Expected an 'openspec' folder."
            currentDirectory = nil
        } catch DirectoryScanner.ScanError.notADirectory {
            errorMessage = "Selected path is not a directory."
            currentDirectory = nil
        } catch {
            errorMessage = "Failed to load directory: \(error.localizedDescription)"
            currentDirectory = nil
        }

        isLoading = false
    }

    func closeDirectory() {
        currentDirectory = nil
        selectedItem = nil
        errorMessage = nil
    }

    func refresh() async {
        guard let url = currentDirectory?.url else { return }
        await loadDirectory(url: url)
    }

    func clearError() {
        errorMessage = nil
    }

    func setError(_ message: String) {
        errorMessage = message
    }
}
