# Tasks: Increase Unit Test Coverage

## 1. ArchivedChange Model Tests
- [x] 1.1 Test `archiveDate` parsing from valid date prefixes (e.g., "2024-01-15-add-feature")
- [x] 1.2 Test `archiveDate` returns nil for invalid/missing prefixes
- [x] 1.3 Test `changeName` extraction from prefixed IDs
- [x] 1.4 Test `changeName` returns full ID when no prefix
- [x] 1.5 Test `displayName` formatting (dashes to spaces, capitalized)

## 2. SidebarItem Tests
- [x] 2.1 Test `id` generation for spec items
- [x] 2.2 Test `id` generation for change items
- [x] 2.3 Test `id` generation for archived change items
- [x] 2.4 Test `displayName` for all item types
- [x] 2.5 Test `content` property for spec items (spec and design files)
- [x] 2.6 Test `content` property for change items (proposal, tasks, design, specDelta)
- [x] 2.7 Test `content` property for archived change items
- [x] 2.8 Test `changeId` returns nil for specs, correct ID for changes/archives

## 3. SpecFile and ChangeFile Enum Tests
- [x] 3.1 Test `SpecFile.rawValue` for all cases
- [x] 3.2 Test `SpecFile.displayName` for all cases
- [x] 3.3 Test `ChangeFile.rawValue` for all cases including specDelta
- [x] 3.4 Test `ChangeFile.displayName` for all cases

## 4. SpecDelta Model Tests
- [x] 4.1 Test `id` computed from specName
- [x] 4.2 Test initialization and property access

## 5. DirectoryScanner Extended Tests
- [x] 5.1 Test scanning with design.md files present
- [x] 5.2 Test scanning archived changes
- [x] 5.3 Test scanning changes with spec deltas
- [x] 5.4 Test project.md title extraction
- [x] 5.5 Test project.md fallback when no title

## 6. RecentDirectoriesService Tests
- [x] 6.1 Test `addRecent` adds new directory
- [x] 6.2 Test `addRecent` moves existing directory to top
- [x] 6.3 Test `addRecent` respects maxRecent limit (10)
- [x] 6.4 Test `removeRecent` removes directory
- [x] 6.5 Test `clearRecent` removes all directories
- [x] 6.6 Test `resolveBookmark` returns URL for directory without bookmark

## 7. Logger Tests Extension
- [x] 7.1 Test all log levels (debug, info, notice, error, fault)
- [x] 7.2 Test signpost methods don't crash
- [x] 7.3 Test OSLogType description for all types

## 8. Validation
- [x] 8.1 Run full test suite
- [x] 8.2 Verify coverage increased from baseline
- [x] 8.3 Ensure no test failures
