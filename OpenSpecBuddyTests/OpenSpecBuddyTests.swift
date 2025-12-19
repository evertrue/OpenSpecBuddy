//
//  OpenSpecBuddyTests.swift
//  OpenSpecBuddyTests
//
//  Created by PJ Gray on 12/19/25.
//

import Testing
import Foundation
@testable import OpenSpecBuddy

struct ModelTests {

    @Test func specDisplayName() async throws {
        let spec = Spec(id: "user-authentication", url: URL(fileURLWithPath: "/test"), specContent: nil, designContent: nil)
        #expect(spec.displayName == "User Authentication")
    }

    @Test func specHasDesign() async throws {
        let specWithDesign = Spec(id: "auth", url: URL(fileURLWithPath: "/test"), specContent: "# Spec", designContent: "# Design")
        let specWithoutDesign = Spec(id: "auth", url: URL(fileURLWithPath: "/test"), specContent: "# Spec", designContent: nil)

        #expect(specWithDesign.hasDesign == true)
        #expect(specWithoutDesign.hasDesign == false)
    }

    @Test func changeDisplayName() async throws {
        let change = Change(id: "add-dark-mode", url: URL(fileURLWithPath: "/test"))
        #expect(change.displayName == "Add Dark Mode")
    }

    @Test func changeHasDesignAndTasks() async throws {
        let changeComplete = Change(id: "test", url: URL(fileURLWithPath: "/test"), proposal: "# Proposal", tasks: "# Tasks", design: "# Design")
        let changeMinimal = Change(id: "test", url: URL(fileURLWithPath: "/test"), proposal: "# Proposal")

        #expect(changeComplete.hasDesign == true)
        #expect(changeComplete.hasTasks == true)
        #expect(changeMinimal.hasDesign == false)
        #expect(changeMinimal.hasTasks == false)
    }

    @Test func openSpecDirectoryDisplayName() async throws {
        let dirWithProject = OpenSpecDirectory(
            url: URL(fileURLWithPath: "/test/my-project"),
            projectInfo: ProjectInfo(name: "My Project", version: "1.0")
        )
        let dirWithoutProject = OpenSpecDirectory(url: URL(fileURLWithPath: "/test/my-project"))

        #expect(dirWithProject.displayName == "My Project")
        #expect(dirWithoutProject.displayName == "my-project")
    }

    @Test func sidebarItemContent() async throws {
        let spec = Spec(id: "auth", url: URL(fileURLWithPath: "/test"), specContent: "# Auth Spec", designContent: "# Design")
        let specItem = SidebarItem.spec(spec, file: .spec)
        let designItem = SidebarItem.spec(spec, file: .design)

        #expect(specItem.content == "# Auth Spec")
        #expect(designItem.content == "# Design")
    }
}

struct DirectoryScannerTests {

    @Test func scanThrowsForNonDirectory() async throws {
        let scanner = DirectoryScanner()
        let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent("testfile.txt")
        FileManager.default.createFile(atPath: tempFile.path, contents: nil)
        defer { try? FileManager.default.removeItem(at: tempFile) }

        do {
            _ = try await scanner.scan(url: tempFile)
            #expect(Bool(false), "Should have thrown an error")
        } catch DirectoryScanner.ScanError.notADirectory {
            // Expected
        } catch {
            #expect(Bool(false), "Wrong error type: \(error)")
        }
    }

    @Test func scanThrowsForNonOpenSpecDirectory() async throws {
        let scanner = DirectoryScanner()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        do {
            _ = try await scanner.scan(url: tempDir)
            #expect(Bool(false), "Should have thrown an error")
        } catch DirectoryScanner.ScanError.notAnOpenSpecDirectory {
            // Expected
        } catch {
            #expect(Bool(false), "Wrong error type: \(error)")
        }
    }

    @Test func scanFindsSpecs() async throws {
        let scanner = DirectoryScanner()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let openspecDir = tempDir.appendingPathComponent("openspec")
        let specsDir = openspecDir.appendingPathComponent("specs")
        let authDir = specsDir.appendingPathComponent("auth")

        try FileManager.default.createDirectory(at: authDir, withIntermediateDirectories: true)
        try "# Authentication".write(to: authDir.appendingPathComponent("spec.md"), atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let result = try await scanner.scan(url: tempDir)

        #expect(result.specs.count == 1)
        #expect(result.specs.first?.id == "auth")
        #expect(result.specs.first?.specContent == "# Authentication")
    }

    @Test func scanFindsChanges() async throws {
        let scanner = DirectoryScanner()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let openspecDir = tempDir.appendingPathComponent("openspec")
        let changesDir = openspecDir.appendingPathComponent("changes")
        let changeDir = changesDir.appendingPathComponent("add-feature")

        try FileManager.default.createDirectory(at: changeDir, withIntermediateDirectories: true)
        try "# Proposal".write(to: changeDir.appendingPathComponent("proposal.md"), atomically: true, encoding: .utf8)
        try "# Tasks".write(to: changeDir.appendingPathComponent("tasks.md"), atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let result = try await scanner.scan(url: tempDir)

        #expect(result.changes.count == 1)
        #expect(result.changes.first?.id == "add-feature")
        #expect(result.changes.first?.proposal == "# Proposal")
        #expect(result.changes.first?.tasks == "# Tasks")
    }
}
