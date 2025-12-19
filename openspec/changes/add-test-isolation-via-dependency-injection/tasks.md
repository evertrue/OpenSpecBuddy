## 1. Refactor RecentDirectoriesService for Dependency Injection
- [ ] 1.1 Add `userDefaults: UserDefaults` parameter to `RecentDirectoriesService.init` with default value `.standard`
- [ ] 1.2 Store `userDefaults` as private instance property
- [ ] 1.3 Update `loadRecent()` to use instance property instead of `UserDefaults.standard`
- [ ] 1.4 Update `saveRecent()` to use instance property instead of `UserDefaults.standard`

## 2. Refactor AppViewModel for Dependency Injection
- [ ] 2.1 Change `recentDirectoriesService` from direct instantiation to constructor parameter with default
- [ ] 2.2 Change `scanner` from direct instantiation to constructor parameter with default
- [ ] 2.3 Verify production code still works with default parameters

## 3. Update Tests to Use Isolated Dependencies
- [ ] 3.1 Create test helper for generating isolated `UserDefaults` instances
- [ ] 3.2 Update `RecentDirectoriesServiceTests` to use isolated `UserDefaults`
- [ ] 3.3 Add cleanup in test teardown to remove test suite data

## 4. Add Test Fixture Helpers
- [ ] 4.1 Create `TestOpenSpecDirectory` helper struct for test fixtures
- [ ] 4.2 Refactor `DirectoryScannerTests` to use the helper
- [ ] 4.3 Add helper methods for common test scenarios (addSpec, addChange, addArchived)

## 5. Verify Test Isolation
- [ ] 5.1 Run full test suite and verify no side effects on real UserDefaults
- [ ] 5.2 Build the application and confirm recently opened directories are not affected by tests
