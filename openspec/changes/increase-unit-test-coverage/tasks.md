# Tasks: Increase Unit Test Coverage

## 1. ArchivedChange Model Tests
- [ ] 1.1 Test `archiveDate` parsing from valid date prefixes (e.g., "2024-01-15-add-feature")
- [ ] 1.2 Test `archiveDate` returns nil for invalid/missing prefixes
- [ ] 1.3 Test `changeName` extraction from prefixed IDs
- [ ] 1.4 Test `changeName` returns full ID when no prefix
- [ ] 1.5 Test `displayName` formatting (dashes to spaces, capitalized)

## 2. SidebarItem Tests
- [ ] 2.1 Test `id` generation for spec items
- [ ] 2.2 Test `id` generation for change items
- [ ] 2.3 Test `id` generation for archived change items
- [ ] 2.4 Test `displayName` for all item types
- [ ] 2.5 Test `content` property for spec items (spec and design files)
- [ ] 2.6 Test `content` property for change items (proposal, tasks, design, specDelta)
- [ ] 2.7 Test `content` property for archived change items
- [ ] 2.8 Test `changeId` returns nil for specs, correct ID for changes/archives

## 3. SpecFile and ChangeFile Enum Tests
- [ ] 3.1 Test `SpecFile.rawValue` for all cases
- [ ] 3.2 Test `SpecFile.displayName` for all cases
- [ ] 3.3 Test `ChangeFile.rawValue` for all cases including specDelta
- [ ] 3.4 Test `ChangeFile.displayName` for all cases

## 4. SpecDelta Model Tests
- [ ] 4.1 Test `id` computed from specName
- [ ] 4.2 Test initialization and property access

## 5. DirectoryScanner Extended Tests
- [ ] 5.1 Test scanning with design.md files present
- [ ] 5.2 Test scanning archived changes
- [ ] 5.3 Test scanning changes with spec deltas
- [ ] 5.4 Test project.md title extraction
- [ ] 5.5 Test project.md fallback when no title

## 6. RecentDirectoriesService Tests
- [ ] 6.1 Test `addRecent` adds new directory
- [ ] 6.2 Test `addRecent` moves existing directory to top
- [ ] 6.3 Test `addRecent` respects maxRecent limit (10)
- [ ] 6.4 Test `removeRecent` removes directory
- [ ] 6.5 Test `clearRecent` removes all directories
- [ ] 6.6 Test `resolveBookmark` returns URL for directory without bookmark

## 7. Logger Tests Extension
- [ ] 7.1 Test all log levels (debug, info, notice, error, fault)
- [ ] 7.2 Test signpost methods don't crash
- [ ] 7.3 Test OSLogType description for all types

## 8. Validation
- [ ] 8.1 Run full test suite
- [ ] 8.2 Verify coverage increased from baseline
- [ ] 8.3 Ensure no test failures
