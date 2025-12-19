## ADDED Requirements
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
