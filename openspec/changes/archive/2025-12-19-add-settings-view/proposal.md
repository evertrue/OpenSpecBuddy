# Change: Add Settings View

## Why
Users need a way to manage application settings, starting with the ability to clear recently opened directories when the list becomes cluttered or contains stale entries.

## What Changes
- Add a gear icon button in the toolbar that opens a settings sheet
- Create a new SettingsView with a "Clear Recent Directories" option
- Wire up the settings to the existing `RecentDirectoriesService.clearRecent()` method
- Settings view is extensible for future configuration options

## Impact
- Affected specs: directory-management (adds settings access for recent directories)
- Affected code:
  - `ContentView.swift` - add settings button to toolbar
  - New `Views/Settings/SettingsView.swift` - settings UI
  - `AppViewModel.swift` - add settings sheet state
