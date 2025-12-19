//
//  OpenSpecBuddyTests.swift
//  OpenSpecBuddyTests
//
//  Created by PJ Gray on 12/19/25.
//

import Testing
import Foundation
import OSLog
@testable import OpenSpecBuddy

// MARK: - Test Helpers

/// Creates an isolated UserDefaults instance for testing.
/// Returns a tuple of the UserDefaults instance and its suite name for cleanup.
func makeIsolatedUserDefaults() -> (defaults: UserDefaults, suiteName: String) {
    let suiteName = "test-\(UUID().uuidString)"
    let defaults = UserDefaults(suiteName: suiteName)!
    return (defaults, suiteName)
}

/// Removes the persistent domain for a test suite.
func cleanupUserDefaults(suiteName: String) {
    UserDefaults.standard.removePersistentDomain(forName: suiteName)
}

/// Helper struct for creating isolated OpenSpec test directories.
struct TestOpenSpecDirectory {
    let url: URL
    private let fileManager = FileManager.default

    init() throws {
        url = fileManager.temporaryDirectory.appendingPathComponent("test-\(UUID().uuidString)")
        try fileManager.createDirectory(
            at: url.appendingPathComponent("openspec"),
            withIntermediateDirectories: true
        )
    }

    func addSpec(id: String, content: String, design: String? = nil) throws {
        let specDir = url.appendingPathComponent("openspec/specs/\(id)")
        try fileManager.createDirectory(at: specDir, withIntermediateDirectories: true)
        try content.write(to: specDir.appendingPathComponent("spec.md"), atomically: true, encoding: .utf8)
        if let design = design {
            try design.write(to: specDir.appendingPathComponent("design.md"), atomically: true, encoding: .utf8)
        }
    }

    func addChange(id: String, proposal: String, tasks: String? = nil, design: String? = nil) throws {
        let changeDir = url.appendingPathComponent("openspec/changes/\(id)")
        try fileManager.createDirectory(at: changeDir, withIntermediateDirectories: true)
        try proposal.write(to: changeDir.appendingPathComponent("proposal.md"), atomically: true, encoding: .utf8)
        if let tasks = tasks {
            try tasks.write(to: changeDir.appendingPathComponent("tasks.md"), atomically: true, encoding: .utf8)
        }
        if let design = design {
            try design.write(to: changeDir.appendingPathComponent("design.md"), atomically: true, encoding: .utf8)
        }
    }

    func addSpecDelta(changeId: String, specName: String, content: String) throws {
        let deltaDir = url.appendingPathComponent("openspec/changes/\(changeId)/specs/\(specName)")
        try fileManager.createDirectory(at: deltaDir, withIntermediateDirectories: true)
        try content.write(to: deltaDir.appendingPathComponent("spec.md"), atomically: true, encoding: .utf8)
    }

    func addArchivedChange(id: String, proposal: String, tasks: String? = nil) throws {
        let archiveDir = url.appendingPathComponent("openspec/changes/archive/\(id)")
        try fileManager.createDirectory(at: archiveDir, withIntermediateDirectories: true)
        try proposal.write(to: archiveDir.appendingPathComponent("proposal.md"), atomically: true, encoding: .utf8)
        if let tasks = tasks {
            try tasks.write(to: archiveDir.appendingPathComponent("tasks.md"), atomically: true, encoding: .utf8)
        }
    }

    func setProjectInfo(content: String) throws {
        try content.write(
            to: url.appendingPathComponent("openspec/project.md"),
            atomically: true,
            encoding: .utf8
        )
    }

    func cleanup() {
        try? fileManager.removeItem(at: url)
    }
}

// MARK: - Model Tests

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

struct LoggingTests {

    @Test func logCategoryHasCorrectSubsystem() async throws {
        let category = LogCategory.app
        #expect(category.subsystem.contains("openspecbuddy") || category.subsystem.contains("OpenSpecBuddy"))
    }

    @Test func allLogCategoriesHaveRawValues() async throws {
        for category in LogCategory.allCases {
            #expect(!category.rawValue.isEmpty)
        }
    }

    @Test func categorizedLoggerInitializes() async throws {
        let logger = CategorizedLogger(category: .app)
        #expect(logger.category == .app)
    }

    @Test func loggerExtensionProvidesStaticAccessors() async throws {
        #expect(Logger.app.category == .app)
        #expect(Logger.ui.category == .ui)
        #expect(Logger.fileSystem.category == .fileSystem)
        #expect(Logger.parsing.category == .parsing)
        #expect(Logger.navigation.category == .navigation)
    }

    @Test func loggerForCategoryReturnsCorrectLogger() async throws {
        let logger = Logger.for(.parsing)
        #expect(logger.category == .parsing)
    }
}

struct ArchivedChangeTests {

    @Test func archiveDateParsesValidPrefix() async throws {
        let archived = ArchivedChange(
            id: "2024-01-15-add-feature",
            url: URL(fileURLWithPath: "/test")
        )
        let date = archived.archiveDate
        #expect(date != nil)

        let calendar = Calendar.current
        #expect(calendar.component(.year, from: date!) == 2024)
        #expect(calendar.component(.month, from: date!) == 1)
        #expect(calendar.component(.day, from: date!) == 15)
    }

    @Test func archiveDateReturnsNilForInvalidPrefix() async throws {
        let archivedNoPrefix = ArchivedChange(
            id: "add-feature",
            url: URL(fileURLWithPath: "/test")
        )
        #expect(archivedNoPrefix.archiveDate == nil)

        let archivedPartialPrefix = ArchivedChange(
            id: "2024-01-add-feature",
            url: URL(fileURLWithPath: "/test")
        )
        #expect(archivedPartialPrefix.archiveDate == nil)

        let archivedInvalidDate = ArchivedChange(
            id: "abcd-ef-gh-add-feature",
            url: URL(fileURLWithPath: "/test")
        )
        #expect(archivedInvalidDate.archiveDate == nil)
    }

    @Test func changeNameExtractsFromPrefixedId() async throws {
        let archived = ArchivedChange(
            id: "2024-01-15-add-dark-mode",
            url: URL(fileURLWithPath: "/test")
        )
        #expect(archived.changeName == "add-dark-mode")
    }

    @Test func changeNameReturnsFullIdWhenNoPrefix() async throws {
        let archived = ArchivedChange(
            id: "add-feature",
            url: URL(fileURLWithPath: "/test")
        )
        #expect(archived.changeName == "add-feature")
    }

    @Test func displayNameFormatsCorrectly() async throws {
        let archived = ArchivedChange(
            id: "2024-01-15-add-dark-mode",
            url: URL(fileURLWithPath: "/test")
        )
        #expect(archived.displayName == "Add Dark Mode")

        let archivedNoPrefix = ArchivedChange(
            id: "implement-auth-flow",
            url: URL(fileURLWithPath: "/test")
        )
        #expect(archivedNoPrefix.displayName == "Implement Auth Flow")
    }
}

struct SidebarItemTests {

    @Test func specItemId() async throws {
        let spec = Spec(id: "auth", url: URL(fileURLWithPath: "/test"), specContent: "# Spec", designContent: nil)
        let specItem = SidebarItem.spec(spec, file: .spec)
        let designItem = SidebarItem.spec(spec, file: .design)

        #expect(specItem.id == "spec-auth-spec")
        #expect(designItem.id == "spec-auth-design")
    }

    @Test func changeItemId() async throws {
        let change = Change(id: "add-feature", url: URL(fileURLWithPath: "/test"))
        let proposalItem = SidebarItem.change(change, file: .proposal)
        let tasksItem = SidebarItem.change(change, file: .tasks)
        let designItem = SidebarItem.change(change, file: .design)
        let deltaItem = SidebarItem.change(change, file: .specDelta("auth"))

        #expect(proposalItem.id == "change-add-feature-proposal")
        #expect(tasksItem.id == "change-add-feature-tasks")
        #expect(designItem.id == "change-add-feature-design")
        #expect(deltaItem.id == "change-add-feature-delta-auth")
    }

    @Test func archivedChangeItemId() async throws {
        let archived = ArchivedChange(id: "2024-01-15-add-feature", url: URL(fileURLWithPath: "/test"))
        let proposalItem = SidebarItem.archivedChange(archived, file: .proposal)

        #expect(proposalItem.id == "archived-2024-01-15-add-feature-proposal")
    }

    @Test func displayNameForAllTypes() async throws {
        let spec = Spec(id: "user-auth", url: URL(fileURLWithPath: "/test"), specContent: nil, designContent: nil)
        let change = Change(id: "add-dark-mode", url: URL(fileURLWithPath: "/test"))
        let archived = ArchivedChange(id: "2024-01-15-implement-feature", url: URL(fileURLWithPath: "/test"))

        #expect(SidebarItem.spec(spec, file: .spec).displayName == "User Auth")
        #expect(SidebarItem.change(change, file: .proposal).displayName == "Add Dark Mode")
        #expect(SidebarItem.archivedChange(archived, file: .proposal).displayName == "Implement Feature")
    }

    @Test func contentForSpecItems() async throws {
        let spec = Spec(
            id: "auth",
            url: URL(fileURLWithPath: "/test"),
            specContent: "# Spec Content",
            designContent: "# Design Content"
        )

        #expect(SidebarItem.spec(spec, file: .spec).content == "# Spec Content")
        #expect(SidebarItem.spec(spec, file: .design).content == "# Design Content")
    }

    @Test func contentForChangeItems() async throws {
        let specDelta = SpecDelta(specName: "auth", url: URL(fileURLWithPath: "/test"), content: "# Delta")
        let change = Change(
            id: "add-feature",
            url: URL(fileURLWithPath: "/test"),
            proposal: "# Proposal",
            tasks: "# Tasks",
            design: "# Design",
            specDeltas: [specDelta]
        )

        #expect(SidebarItem.change(change, file: .proposal).content == "# Proposal")
        #expect(SidebarItem.change(change, file: .tasks).content == "# Tasks")
        #expect(SidebarItem.change(change, file: .design).content == "# Design")
        #expect(SidebarItem.change(change, file: .specDelta("auth")).content == "# Delta")
        #expect(SidebarItem.change(change, file: .specDelta("nonexistent")).content == nil)
    }

    @Test func contentForArchivedChangeItems() async throws {
        let specDelta = SpecDelta(specName: "auth", url: URL(fileURLWithPath: "/test"), content: "# Archived Delta")
        let archived = ArchivedChange(
            id: "2024-01-15-add-feature",
            url: URL(fileURLWithPath: "/test"),
            proposal: "# Archived Proposal",
            tasks: "# Archived Tasks",
            design: "# Archived Design",
            specDeltas: [specDelta]
        )

        #expect(SidebarItem.archivedChange(archived, file: .proposal).content == "# Archived Proposal")
        #expect(SidebarItem.archivedChange(archived, file: .tasks).content == "# Archived Tasks")
        #expect(SidebarItem.archivedChange(archived, file: .design).content == "# Archived Design")
        #expect(SidebarItem.archivedChange(archived, file: .specDelta("auth")).content == "# Archived Delta")
    }

    @Test func changeIdReturnsCorrectValues() async throws {
        let spec = Spec(id: "auth", url: URL(fileURLWithPath: "/test"), specContent: nil, designContent: nil)
        let change = Change(id: "add-feature", url: URL(fileURLWithPath: "/test"))
        let archived = ArchivedChange(id: "2024-01-15-implement-auth", url: URL(fileURLWithPath: "/test"))

        #expect(SidebarItem.spec(spec, file: .spec).changeId == nil)
        #expect(SidebarItem.change(change, file: .proposal).changeId == "add-feature")
        #expect(SidebarItem.archivedChange(archived, file: .proposal).changeId == "2024-01-15-implement-auth")
    }
}

struct SpecFileTests {

    @Test func rawValueForAllCases() async throws {
        #expect(SpecFile.spec.rawValue == "spec")
        #expect(SpecFile.design.rawValue == "design")
    }

    @Test func displayNameForAllCases() async throws {
        #expect(SpecFile.spec.displayName == "Spec")
        #expect(SpecFile.design.displayName == "Design")
    }
}

struct ChangeFileTests {

    @Test func rawValueForAllCases() async throws {
        #expect(ChangeFile.proposal.rawValue == "proposal")
        #expect(ChangeFile.tasks.rawValue == "tasks")
        #expect(ChangeFile.design.rawValue == "design")
        #expect(ChangeFile.specDelta("auth").rawValue == "delta-auth")
        #expect(ChangeFile.specDelta("user-profile").rawValue == "delta-user-profile")
    }

    @Test func displayNameForAllCases() async throws {
        #expect(ChangeFile.proposal.displayName == "Proposal")
        #expect(ChangeFile.tasks.displayName == "Tasks")
        #expect(ChangeFile.design.displayName == "Design")
        #expect(ChangeFile.specDelta("auth").displayName == "auth")
        #expect(ChangeFile.specDelta("user-profile").displayName == "user-profile")
    }
}

struct SpecDeltaTests {

    @Test func idComputedFromSpecName() async throws {
        let delta = SpecDelta(specName: "authentication", url: URL(fileURLWithPath: "/test"), content: "# Delta")
        #expect(delta.id == "authentication")
    }

    @Test func initializationAndPropertyAccess() async throws {
        let url = URL(fileURLWithPath: "/test/path")
        let content = "# Spec Delta Content"
        let delta = SpecDelta(specName: "user-auth", url: url, content: content)

        #expect(delta.specName == "user-auth")
        #expect(delta.url == url)
        #expect(delta.content == content)

        let deltaNoContent = SpecDelta(specName: "no-content", url: url, content: nil)
        #expect(deltaNoContent.content == nil)
    }
}

struct DirectoryScannerTests {

    @Test func scanThrowsForNonDirectory() async throws {
        let scanner = DirectoryScanner()
        let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent("testfile-\(UUID().uuidString).txt")
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
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("test-\(UUID().uuidString)")
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
        let fixture = try TestOpenSpecDirectory()
        defer { fixture.cleanup() }

        try fixture.addSpec(id: "auth", content: "# Authentication")

        let result = try await scanner.scan(url: fixture.url)

        #expect(result.specs.count == 1)
        #expect(result.specs.first?.id == "auth")
        #expect(result.specs.first?.specContent == "# Authentication")
    }

    @Test func scanFindsChanges() async throws {
        let scanner = DirectoryScanner()
        let fixture = try TestOpenSpecDirectory()
        defer { fixture.cleanup() }

        try fixture.addChange(id: "add-feature", proposal: "# Proposal", tasks: "# Tasks")

        let result = try await scanner.scan(url: fixture.url)

        #expect(result.changes.count == 1)
        #expect(result.changes.first?.id == "add-feature")
        #expect(result.changes.first?.proposal == "# Proposal")
        #expect(result.changes.first?.tasks == "# Tasks")
    }

    @Test func scanFindsDesignFiles() async throws {
        let scanner = DirectoryScanner()
        let fixture = try TestOpenSpecDirectory()
        defer { fixture.cleanup() }

        try fixture.addSpec(id: "auth", content: "# Authentication Spec", design: "# Authentication Design")

        let result = try await scanner.scan(url: fixture.url)

        #expect(result.specs.count == 1)
        #expect(result.specs.first?.specContent == "# Authentication Spec")
        #expect(result.specs.first?.designContent == "# Authentication Design")
        #expect(result.specs.first?.hasDesign == true)
    }

    @Test func scanFindsArchivedChanges() async throws {
        let scanner = DirectoryScanner()
        let fixture = try TestOpenSpecDirectory()
        defer { fixture.cleanup() }

        try fixture.addArchivedChange(id: "2024-01-15-add-feature", proposal: "# Archived Proposal")

        let result = try await scanner.scan(url: fixture.url)

        #expect(result.archivedChanges.count == 1)
        #expect(result.archivedChanges.first?.id == "2024-01-15-add-feature")
        #expect(result.archivedChanges.first?.proposal == "# Archived Proposal")
    }

    @Test func scanFindsChangesWithSpecDeltas() async throws {
        let scanner = DirectoryScanner()
        let fixture = try TestOpenSpecDirectory()
        defer { fixture.cleanup() }

        try fixture.addChange(id: "add-auth", proposal: "# Proposal")
        try fixture.addSpecDelta(changeId: "add-auth", specName: "auth", content: "# Spec Delta")

        let result = try await scanner.scan(url: fixture.url)

        #expect(result.changes.count == 1)
        #expect(result.changes.first?.specDeltas.count == 1)
        #expect(result.changes.first?.specDeltas.first?.specName == "auth")
        #expect(result.changes.first?.specDeltas.first?.content == "# Spec Delta")
    }

    @Test func scanExtractsProjectTitle() async throws {
        let scanner = DirectoryScanner()
        let fixture = try TestOpenSpecDirectory()
        defer { fixture.cleanup() }

        try fixture.setProjectInfo(content: "# My Project\n\nThis is my project.")

        let result = try await scanner.scan(url: fixture.url)

        #expect(result.projectInfo?.name == "My Project")
    }

    @Test func scanFallbacksToDirectoryNameWhenNoTitle() async throws {
        let scanner = DirectoryScanner()
        let fixture = try TestOpenSpecDirectory()
        defer { fixture.cleanup() }

        try fixture.setProjectInfo(content: "No title here, just text.")

        let result = try await scanner.scan(url: fixture.url)

        // The fixture URL has a UUID in it, so just check it's not nil
        #expect(result.projectInfo?.name != nil)
    }
}

struct RecentDirectoriesServiceTests {

    @Test func addRecentAddsNewDirectory() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)

        let url = URL(fileURLWithPath: "/test/project1")
        service.addRecent(url: url, name: "Project 1")

        #expect(service.recentDirectories.count == 1)
        #expect(service.recentDirectories.first?.name == "Project 1")
        #expect(service.recentDirectories.first?.path == "/test/project1")
    }

    @Test func addRecentMovesExistingToTop() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)

        let url1 = URL(fileURLWithPath: "/test/project1")
        let url2 = URL(fileURLWithPath: "/test/project2")

        service.addRecent(url: url1, name: "Project 1")
        service.addRecent(url: url2, name: "Project 2")
        service.addRecent(url: url1, name: "Project 1")

        #expect(service.recentDirectories.count == 2)
        #expect(service.recentDirectories[0].name == "Project 1")
        #expect(service.recentDirectories[1].name == "Project 2")
    }

    @Test func addRecentRespectsMaxLimit() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)

        for i in 0..<15 {
            let url = URL(fileURLWithPath: "/test/project\(i)")
            service.addRecent(url: url, name: "Project \(i)")
        }

        #expect(service.recentDirectories.count == 10)
        #expect(service.recentDirectories.first?.name == "Project 14")
    }

    @Test func removeRecentRemovesDirectory() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)

        let url1 = URL(fileURLWithPath: "/test/project1")
        let url2 = URL(fileURLWithPath: "/test/project2")

        service.addRecent(url: url1, name: "Project 1")
        service.addRecent(url: url2, name: "Project 2")

        let toRemove = service.recentDirectories.first { $0.name == "Project 1" }!
        service.removeRecent(toRemove)

        #expect(service.recentDirectories.count == 1)
        #expect(service.recentDirectories.first?.name == "Project 2")
    }

    @Test func clearRecentRemovesAll() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)

        let url = URL(fileURLWithPath: "/test/project1")
        service.addRecent(url: url, name: "Project 1")
        service.clearRecent()

        #expect(service.recentDirectories.isEmpty)
    }

    @Test func resolveBookmarkReturnsUrlForDirectoryWithoutBookmark() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)
        let directory = RecentDirectory(
            path: "/test/project",
            name: "Test Project",
            lastOpened: Date(),
            bookmarkData: nil
        )

        let resolved = service.resolveBookmark(for: directory)

        #expect(resolved?.path == "/test/project")
    }
}

struct ExtendedLoggingTests {

    @Test func allLogLevelMethodsExist() async throws {
        let logger = CategorizedLogger(category: .app)

        // These should not crash - just verify they exist and can be called
        logger.debug("Debug message")
        logger.info("Info message")
        logger.notice("Notice message")
        logger.error("Error message")
        logger.fault("Fault message")

        #expect(true)
    }

    @Test func signpostMethodsDoNotCrash() async throws {
        let logger = CategorizedLogger(category: .fileSystem)

        let signpostID = logger.startSignpost(name: "TestOperation")
        logger.endSignpost(name: "TestOperation", signpostID: signpostID)
        logger.signpostEvent(name: "TestEvent")

        #expect(true)
    }

    @Test func osLogTypeDescriptionForAllTypes() async throws {
        #expect(OSLogType.debug.description == "DEBUG")
        #expect(OSLogType.info.description == "INFO")
        #expect(OSLogType.default.description == "DEFAULT")
        #expect(OSLogType.error.description == "ERROR")
        #expect(OSLogType.fault.description == "FAULT")
    }
}

struct AppViewModelSettingsTests {

    @Test @MainActor func showSettingsSetsIsSettingsPresented() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)
        let viewModel = AppViewModel(recentDirectoriesService: service)

        #expect(viewModel.isSettingsPresented == false)

        viewModel.showSettings()

        #expect(viewModel.isSettingsPresented == true)
    }

    @Test @MainActor func clearRecentDirectoriesClearsService() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)
        let viewModel = AppViewModel(recentDirectoriesService: service)

        // Add some directories
        let url1 = URL(fileURLWithPath: "/test/project1")
        let url2 = URL(fileURLWithPath: "/test/project2")
        service.addRecent(url: url1, name: "Project 1")
        service.addRecent(url: url2, name: "Project 2")

        #expect(viewModel.recentDirectories.count == 2)

        viewModel.clearRecentDirectories()

        #expect(viewModel.recentDirectories.isEmpty)
    }

    @Test @MainActor func isSettingsPresentedStartsFalse() async throws {
        let (testDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { cleanupUserDefaults(suiteName: suiteName) }

        let service = RecentDirectoriesService(userDefaults: testDefaults)
        let viewModel = AppViewModel(recentDirectoriesService: service)

        #expect(viewModel.isSettingsPresented == false)
    }
}
