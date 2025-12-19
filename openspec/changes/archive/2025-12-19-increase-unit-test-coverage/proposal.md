# Change: Increase Unit Test Coverage

## Why
Current code coverage is at 25% overall. Several pure-logic files (models, services) have 0-13% coverage despite being easily testable without UI dependencies. Increasing unit test coverage improves code quality and catches regressions early.

## What Changes
- Add comprehensive tests for `ArchivedChange` model (currently 0%)
- Add comprehensive tests for `SidebarItem` enum (currently 12.9%)
- Add comprehensive tests for `RecentDirectoriesService` (currently 13.5%)
- Expand `DirectoryScanner` tests (currently 55.5%)
- Add tests for markdown rendering helper function `renderInlineMarkup`
- Expand `Logger+Categories` tests (currently 32.2%)
- Add `SpecDelta`, `SpecFile`, and `ChangeFile` model tests

## Impact
- Affected specs: testing (new capability)
- Affected code: `OpenSpecBuddyTests/` (new test files)
- No changes to production code required (testing existing functionality)
