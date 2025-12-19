//
//  AppViewModel.swift
//  OpenSpecBuddy
//

import Foundation
import OSLog

@Observable
@MainActor
final class AppViewModel {
    private(set) var currentDirectory: OpenSpecDirectory?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var selectedItem: SidebarItem?
    var isFileImporterPresented = false

    let recentDirectoriesService: RecentDirectoriesService
    private let scanner: DirectoryScanner

    init(
        recentDirectoriesService: RecentDirectoriesService = RecentDirectoriesService(),
        scanner: DirectoryScanner = DirectoryScanner()
    ) {
        self.recentDirectoriesService = recentDirectoriesService
        self.scanner = scanner
    }

    var hasDirectory: Bool {
        currentDirectory != nil
    }

    var recentDirectories: [RecentDirectory] {
        recentDirectoriesService.recentDirectories
    }

    func showDirectoryPicker() {
        Logger.ui.debug("Opening directory picker")
        isFileImporterPresented = true
    }

    func openRecentDirectory(_ recent: RecentDirectory) {
        Logger.fileSystem.info("Opening recent directory: \(recent.name)")
        guard let url = recentDirectoriesService.resolveBookmark(for: recent) else {
            Logger.fileSystem.error("Failed to resolve bookmark for: \(recent.path)")
            errorMessage = "Could not access directory: \(recent.path)"
            return
        }

        Task {
            await loadDirectory(url: url, fromBookmark: true)
        }
    }

    func loadDirectory(url: URL, fromBookmark: Bool = false) async {
        Logger.fileSystem.info("Loading directory: \(url.path)")
        isLoading = true
        errorMessage = nil
        selectedItem = nil

        // Start security-scoped access - required for both bookmarks and fileImporter URLs
        let didStartAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let directory = try await scanner.scan(url: url)
            currentDirectory = directory
            recentDirectoriesService.addRecent(url: url, name: directory.displayName)
            Logger.fileSystem.info("Loaded directory '\(directory.displayName)' with \(directory.specs.count) specs, \(directory.changes.count) changes, \(directory.archivedChanges.count) archived")
        } catch DirectoryScanner.ScanError.notAnOpenSpecDirectory {
            Logger.fileSystem.error("Not an OpenSpec directory: \(url.path)")
            errorMessage = "Not an OpenSpec directory. Expected an 'openspec' folder."
            currentDirectory = nil
        } catch DirectoryScanner.ScanError.notADirectory {
            Logger.fileSystem.error("Path is not a directory: \(url.path)")
            errorMessage = "Selected path is not a directory."
            currentDirectory = nil
        } catch {
            Logger.fileSystem.error("Failed to load directory: \(error.localizedDescription)")
            errorMessage = "Failed to load directory: \(error.localizedDescription)"
            currentDirectory = nil
        }

        isLoading = false
    }

    func closeDirectory() {
        Logger.fileSystem.info("Closing directory")
        currentDirectory = nil
        selectedItem = nil
        errorMessage = nil
    }

    func refresh() async {
        guard let url = currentDirectory?.url else { return }
        Logger.fileSystem.debug("Refreshing directory")
        await loadDirectory(url: url)
    }

    func clearError() {
        errorMessage = nil
    }

    func setError(_ message: String) {
        errorMessage = message
    }
}
