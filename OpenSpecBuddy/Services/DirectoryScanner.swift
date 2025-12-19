//
//  DirectoryScanner.swift
//  OpenSpecBuddy
//

import Foundation

actor DirectoryScanner {
    enum ScanError: Error {
        case notADirectory
        case notAnOpenSpecDirectory
        case accessDenied
    }

    func scan(url: URL) async throws -> OpenSpecDirectory {
        let fileManager = FileManager.default

        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            throw ScanError.notADirectory
        }

        let openspecURL = url.appendingPathComponent("openspec")
        guard fileManager.fileExists(atPath: openspecURL.path) else {
            throw ScanError.notAnOpenSpecDirectory
        }

        let projectInfo = try? await loadProjectInfo(from: openspecURL)
        let specs = try await loadSpecs(from: openspecURL)
        let changes = try await loadChanges(from: openspecURL)
        let archivedChanges = try await loadArchivedChanges(from: openspecURL)

        return OpenSpecDirectory(
            url: url,
            projectInfo: projectInfo,
            specs: specs,
            changes: changes,
            archivedChanges: archivedChanges
        )
    }

    private func loadProjectInfo(from openspecURL: URL) async throws -> ProjectInfo? {
        let projectURL = openspecURL.appendingPathComponent("project.md")
        guard FileManager.default.fileExists(atPath: projectURL.path) else {
            return nil
        }

        let content = try String(contentsOf: projectURL, encoding: .utf8)
        let name = extractTitle(from: content) ?? openspecURL.deletingLastPathComponent().lastPathComponent
        return ProjectInfo(name: name, version: nil)
    }

    private func loadSpecs(from openspecURL: URL) async throws -> [Spec] {
        let specsURL = openspecURL.appendingPathComponent("specs")
        guard FileManager.default.fileExists(atPath: specsURL.path) else {
            return []
        }

        let contents = try FileManager.default.contentsOfDirectory(
            at: specsURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        var specs: [Spec] = []
        for itemURL in contents {
            let resourceValues = try itemURL.resourceValues(forKeys: [.isDirectoryKey])
            guard resourceValues.isDirectory == true else { continue }

            let specId = itemURL.lastPathComponent
            let specMdURL = itemURL.appendingPathComponent("spec.md")
            let designMdURL = itemURL.appendingPathComponent("design.md")

            let specContent = try? String(contentsOf: specMdURL, encoding: .utf8)
            let designContent = try? String(contentsOf: designMdURL, encoding: .utf8)

            if specContent != nil {
                specs.append(Spec(
                    id: specId,
                    url: itemURL,
                    specContent: specContent,
                    designContent: designContent
                ))
            }
        }

        return specs.sorted { $0.id < $1.id }
    }

    private func loadChanges(from openspecURL: URL) async throws -> [Change] {
        let changesURL = openspecURL.appendingPathComponent("changes")
        guard FileManager.default.fileExists(atPath: changesURL.path) else {
            return []
        }

        let contents = try FileManager.default.contentsOfDirectory(
            at: changesURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        var changes: [Change] = []
        for itemURL in contents {
            let resourceValues = try itemURL.resourceValues(forKeys: [.isDirectoryKey])
            guard resourceValues.isDirectory == true else { continue }

            // Skip the archive folder - it's handled separately
            let changeId = itemURL.lastPathComponent
            if changeId == "archive" { continue }

            let change = try await loadChange(id: changeId, from: itemURL)
            changes.append(change)
        }

        return changes.sorted { $0.id < $1.id }
    }

    private func loadChange(id: String, from url: URL) async throws -> Change {
        let proposalURL = url.appendingPathComponent("proposal.md")
        let tasksURL = url.appendingPathComponent("tasks.md")
        let designURL = url.appendingPathComponent("design.md")
        let specsURL = url.appendingPathComponent("specs")

        let proposal = try? String(contentsOf: proposalURL, encoding: .utf8)
        let tasks = try? String(contentsOf: tasksURL, encoding: .utf8)
        let design = try? String(contentsOf: designURL, encoding: .utf8)

        var specDeltas: [SpecDelta] = []
        if FileManager.default.fileExists(atPath: specsURL.path) {
            let specContents = try? FileManager.default.contentsOfDirectory(
                at: specsURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            for specURL in specContents ?? [] {
                let resourceValues = try? specURL.resourceValues(forKeys: [.isDirectoryKey])
                guard resourceValues?.isDirectory == true else { continue }

                let specName = specURL.lastPathComponent
                let deltaURL = specURL.appendingPathComponent("spec.md")
                let deltaContent = try? String(contentsOf: deltaURL, encoding: .utf8)

                if deltaContent != nil {
                    specDeltas.append(SpecDelta(
                        specName: specName,
                        url: deltaURL,
                        content: deltaContent
                    ))
                }
            }
        }

        return Change(
            id: id,
            url: url,
            proposal: proposal,
            tasks: tasks,
            design: design,
            specDeltas: specDeltas.sorted { $0.specName < $1.specName }
        )
    }

    private func loadArchivedChanges(from openspecURL: URL) async throws -> [ArchivedChange] {
        // Official OpenSpec location: openspec/changes/archive/
        let archiveURL = openspecURL.appendingPathComponent("changes/archive")
        guard FileManager.default.fileExists(atPath: archiveURL.path) else {
            return []
        }

        let contents = try FileManager.default.contentsOfDirectory(
            at: archiveURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        var archivedChanges: [ArchivedChange] = []
        for itemURL in contents {
            let resourceValues = try itemURL.resourceValues(forKeys: [.isDirectoryKey])
            guard resourceValues.isDirectory == true else { continue }

            let changeId = itemURL.lastPathComponent
            let change = try await loadArchivedChange(id: changeId, from: itemURL)
            archivedChanges.append(change)
        }

        return archivedChanges.sorted { $0.id > $1.id }
    }

    private func loadArchivedChange(id: String, from url: URL) async throws -> ArchivedChange {
        let proposalURL = url.appendingPathComponent("proposal.md")
        let tasksURL = url.appendingPathComponent("tasks.md")
        let designURL = url.appendingPathComponent("design.md")
        let specsURL = url.appendingPathComponent("specs")

        let proposal = try? String(contentsOf: proposalURL, encoding: .utf8)
        let tasks = try? String(contentsOf: tasksURL, encoding: .utf8)
        let design = try? String(contentsOf: designURL, encoding: .utf8)

        var specDeltas: [SpecDelta] = []
        if FileManager.default.fileExists(atPath: specsURL.path) {
            let specContents = try? FileManager.default.contentsOfDirectory(
                at: specsURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            for specURL in specContents ?? [] {
                let resourceValues = try? specURL.resourceValues(forKeys: [.isDirectoryKey])
                guard resourceValues?.isDirectory == true else { continue }

                let specName = specURL.lastPathComponent
                let deltaURL = specURL.appendingPathComponent("spec.md")
                let deltaContent = try? String(contentsOf: deltaURL, encoding: .utf8)

                if deltaContent != nil {
                    specDeltas.append(SpecDelta(
                        specName: specName,
                        url: deltaURL,
                        content: deltaContent
                    ))
                }
            }
        }

        return ArchivedChange(
            id: id,
            url: url,
            proposal: proposal,
            tasks: tasks,
            design: design,
            specDeltas: specDeltas.sorted { $0.specName < $1.specName }
        )
    }

    private func extractTitle(from markdown: String) -> String? {
        let lines = markdown.components(separatedBy: .newlines)
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("# ") {
                return String(trimmed.dropFirst(2)).trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }
}
