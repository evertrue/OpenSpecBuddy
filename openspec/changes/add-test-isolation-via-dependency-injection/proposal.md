# Change: Add Test Isolation via Dependency Injection

## Why
Tests currently write to real `UserDefaults.standard`, causing test data to appear in the application's recently opened directories. This violates test isolation principles and affects the user experience.

## What Changes
- Refactor `RecentDirectoriesService` to accept `UserDefaults` via constructor injection
- Refactor `AppViewModel` to accept services via constructor injection
- Update all tests to use isolated `UserDefaults` instances with unique suite names
- Add test fixture helpers for creating isolated OpenSpec directories

## Impact
- Affected specs: `testing`
- Affected code:
  - `OpenSpecBuddy/Services/RecentDirectoriesService.swift`
  - `OpenSpecBuddy/ViewModels/AppViewModel.swift`
  - `OpenSpecBuddyTests/OpenSpecBuddyTests.swift`
