# directory-management Specification

## Purpose
TBD - created by archiving change add-initial-viewer. Update Purpose after archive.
## Requirements
### Requirement: Open Directory
The system SHALL allow users to select an OpenSpec directory from the file system using a native macOS file picker.

#### Scenario: User opens directory via menu
- **WHEN** user selects File > Open Directory (or presses Cmd+O)
- **THEN** system displays NSOpenPanel configured for directory selection
- **AND** upon selection, system scans the directory for OpenSpec structure

#### Scenario: User opens directory via toolbar
- **WHEN** user clicks the "Open" button in the toolbar
- **THEN** system displays NSOpenPanel configured for directory selection

#### Scenario: Directory lacks openspec folder
- **WHEN** user selects a directory without an `openspec/` subdirectory
- **THEN** system displays an error message indicating invalid OpenSpec directory
- **AND** does not add the directory to recent list

### Requirement: Recent Directories
The system SHALL maintain a list of recently opened directories and allow quick access to them.

#### Scenario: Directory added to recents
- **WHEN** user successfully opens a valid OpenSpec directory
- **THEN** system adds the directory to the recent directories list
- **AND** persists the list across app restarts

#### Scenario: User opens recent directory
- **WHEN** user selects a directory from the recent directories list
- **THEN** system opens and scans that directory
- **AND** moves it to the top of the recent list

#### Scenario: Recent directory no longer exists
- **WHEN** user selects a recent directory that has been deleted or moved
- **THEN** system displays an error message
- **AND** removes the directory from the recent list

### Requirement: Security-Scoped Access
The system SHALL use security-scoped bookmarks to maintain access to user-selected directories across app restarts.

#### Scenario: Bookmark created on directory open
- **WHEN** user selects a directory via file picker
- **THEN** system creates a security-scoped bookmark for that directory
- **AND** stores the bookmark data in UserDefaults

#### Scenario: Bookmark restored on app launch
- **WHEN** app launches with previously opened directories
- **THEN** system resolves security-scoped bookmarks to regain file access
- **AND** handles cases where bookmark resolution fails gracefully

### Requirement: Settings Access
The system SHALL provide a settings interface accessible from the toolbar that allows users to manage application preferences.

#### Scenario: User opens settings via toolbar
- **WHEN** user clicks the settings (gear) button in the toolbar
- **THEN** system displays a settings sheet
- **AND** the sheet contains options for managing application preferences

#### Scenario: User opens settings via keyboard shortcut
- **WHEN** user presses Cmd+, (comma)
- **THEN** system displays the settings sheet

### Requirement: Clear Recent Directories
The system SHALL allow users to clear all recently opened directories from the settings view.

#### Scenario: User clears recent directories
- **WHEN** user clicks "Clear Recent Directories" in the settings view
- **THEN** system displays a confirmation alert
- **AND** upon confirmation, all recent directories are removed from the list
- **AND** the recent directories list is persisted as empty

#### Scenario: User cancels clearing recent directories
- **WHEN** user clicks "Clear Recent Directories" in the settings view
- **AND** user cancels the confirmation alert
- **THEN** recent directories list remains unchanged

