//
//  RecentDirectoriesService.swift
//  OpenSpecBuddy
//

import Foundation

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

    private(set) var recentDirectories: [RecentDirectory] = []

    init() {
        loadRecent()
    }

    func addRecent(url: URL, name: String) {
        var bookmarkData: Data?
        do {
            bookmarkData = try url.bookmarkData(
                options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
        } catch {
            print("Failed to create bookmark for \(url): \(error)")
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
            print("Failed to resolve bookmark for \(directory.path): \(error)")
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
            print("Failed to update bookmark: \(error)")
        }
    }

    private func loadRecent() {
        guard let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey) else {
            return
        }

        do {
            recentDirectories = try JSONDecoder().decode([RecentDirectory].self, from: data)
        } catch {
            print("Failed to decode recent directories: \(error)")
        }
    }

    private func saveRecent() {
        do {
            let data = try JSONEncoder().encode(recentDirectories)
            UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
        } catch {
            print("Failed to encode recent directories: \(error)")
        }
    }
}
