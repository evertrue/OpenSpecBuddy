//
//  RecentDirectoriesService.swift
//  OpenSpecBuddy
//

import Foundation
import OSLog

struct RecentDirectory: Identifiable, Codable, Hashable {
    var id: String { path }
    let path: String
    let name: String
    let lastOpened: Date
    var bookmarkData: Data?

    var url: URL? {
        URL(fileURLWithPath: path)
    }
}

@Observable
final class RecentDirectoriesService: @unchecked Sendable {
    private static let maxRecent = 10
    private static let userDefaultsKey = "recentDirectories"

    private let userDefaults: UserDefaults
    private(set) var recentDirectories: [RecentDirectory] = []

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadRecent()
    }

    func addRecent(url: URL, name: String) {
        Logger.fileSystem.debug("Adding recent directory: \(name)")
        var bookmarkData: Data?
        do {
            bookmarkData = try url.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
        } catch {
            Logger.fileSystem.error("Failed to create bookmark for \(url.path): \(error.localizedDescription)")
        }

        let recent = RecentDirectory(
            path: url.path,
            name: name,
            lastOpened: Date(),
            bookmarkData: bookmarkData
        )

        recentDirectories.removeAll { $0.path == url.path }
        recentDirectories.insert(recent, at: 0)

        if recentDirectories.count > Self.maxRecent {
            recentDirectories = Array(recentDirectories.prefix(Self.maxRecent))
        }

        saveRecent()
    }

    func removeRecent(_ directory: RecentDirectory) {
        recentDirectories.removeAll { $0.id == directory.id }
        saveRecent()
    }

    func clearRecent() {
        recentDirectories.removeAll()
        saveRecent()
    }

    func resolveBookmark(for directory: RecentDirectory) -> URL? {
        guard let bookmarkData = directory.bookmarkData else {
            return directory.url
        }

        var isStale = false
        do {
            let url = try URL(
                resolvingBookmarkData: bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )

            if isStale {
                updateBookmark(for: directory, with: url)
            }

            return url
        } catch {
            Logger.fileSystem.error("Failed to resolve bookmark for \(directory.path): \(error.localizedDescription)")
            return directory.url
        }
    }

    private func updateBookmark(for directory: RecentDirectory, with url: URL) {
        guard let index = recentDirectories.firstIndex(where: { $0.id == directory.id }) else {
            return
        }

        do {
            let newBookmarkData = try url.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            recentDirectories[index].bookmarkData = newBookmarkData
            saveRecent()
        } catch {
            Logger.fileSystem.error("Failed to update bookmark: \(error.localizedDescription)")
        }
    }

    private func loadRecent() {
        guard let data = userDefaults.data(forKey: Self.userDefaultsKey) else {
            Logger.app.debug("No recent directories found in UserDefaults")
            return
        }

        do {
            recentDirectories = try JSONDecoder().decode([RecentDirectory].self, from: data)
            Logger.app.debug("Loaded \(recentDirectories.count) recent directories")
        } catch {
            Logger.app.error("Failed to decode recent directories: \(error.localizedDescription)")
        }
    }

    private func saveRecent() {
        do {
            let data = try JSONEncoder().encode(recentDirectories)
            userDefaults.set(data, forKey: Self.userDefaultsKey)
            Logger.app.debug("Saved \(recentDirectories.count) recent directories")
        } catch {
            Logger.app.error("Failed to encode recent directories: \(error.localizedDescription)")
        }
    }
}
