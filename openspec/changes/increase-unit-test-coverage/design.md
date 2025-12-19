# Design: Increase Unit Test Coverage

## Context
The project has 25% overall test coverage. Several files with pure business logic (models, enums, services) have 0-13% coverage despite being easily testable without UI dependencies. UI tests have been intentionally removed in favor of comprehensive unit testing.

## Goals / Non-Goals

### Goals
- Maximize unit test coverage for non-UI code
- Test all model computed properties and logic
- Test service layer (DirectoryScanner, RecentDirectoriesService)
- Establish consistent testing patterns for future development

### Non-Goals
- UI testing (intentionally excluded from scope)
- 100% line coverage (some code paths require file system mocking)
- Testing SwiftUI view bodies directly

## Decisions

### Decision: Test File Organization
Tests will be organized by domain area in the existing `OpenSpecBuddyTests.swift` file, using Swift Testing's `@Suite` for grouping related tests.

**Rationale**: The existing file already follows this pattern with `ModelTests`, `LoggingTests`, and `DirectoryScannerTests` structs. Maintaining consistency is preferred over splitting into multiple files until the test count warrants it.

### Decision: File System Testing Strategy
For `DirectoryScanner` tests, continue using real temporary directories created in `FileManager.default.temporaryDirectory`.

**Rationale**: The existing tests already use this pattern effectively. It tests actual file system behavior rather than mocked behavior, catching real integration issues.

**Alternatives considered**:
- Protocol-based file system abstraction: More complex, not needed for current scale
- Mocking FileManager: Swift doesn't easily support this pattern

### Decision: RecentDirectoriesService Testing Strategy
Test the in-memory behavior of `RecentDirectoriesService` without persisting to UserDefaults.

**Rationale**: Testing UserDefaults persistence would require cleanup and could interfere with actual app settings. The logic under test is the in-memory list management.

### Decision: Focus on Pure Logic First
Prioritize testing files with pure business logic:
1. `ArchivedChange` - date parsing, name extraction, display formatting
2. `SidebarItem` - all computed properties and content retrieval
3. `SpecFile`/`ChangeFile` - enum raw values and display names
4. `SpecDelta` - model properties

**Rationale**: These have the highest test ROI - simple to test, no dependencies, catches logic errors.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Tests may be flaky due to file system timing | Use unique temp directories per test, clean up in defer blocks |
| Some paths unreachable without mocking | Accept lower coverage for those paths, focus on reachable code |

## Target Coverage

| File | Current | Target | Notes |
|------|---------|--------|-------|
| ArchivedChange.swift | 0% | >90% | Pure model, fully testable |
| SidebarItem.swift | 12.9% | >80% | Pure enum logic |
| RecentDirectoriesService.swift | 13.5% | >60% | Test in-memory operations |
| DirectoryScanner.swift | 55.5% | >70% | Expand edge cases |
| Logger+Categories.swift | 32.2% | >50% | Test all methods |
| Change.swift | 94.4% | >95% | Minor gaps |
| Spec.swift | 100% | 100% | Maintain |

## Open Questions
None - this is a straightforward testing initiative.
