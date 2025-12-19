## MODIFIED Requirements
### Requirement: Archive Section
The system SHALL display all archived changes from the `openspec/changes/archive/` directory with parsed, human-readable labels.

#### Scenario: Archives listed by date and name
- **WHEN** OpenSpec directory contains archived changes
- **THEN** sidebar displays "Archive" section with archived changes
- **AND** each item shows the change name in human-readable format (e.g., "Add Initial Viewer")
- **AND** each item shows the archive date as a styled tag/badge

#### Scenario: Archive date displayed as tag
- **WHEN** an archived change folder follows YYYY-MM-DD-name format
- **THEN** the date portion is displayed as a visually distinct secondary element
- **AND** the date is formatted in a readable style (e.g., "Dec 19, 2025")

#### Scenario: Archive without date prefix
- **WHEN** an archived change folder does not follow YYYY-MM-DD prefix pattern
- **THEN** system displays the folder name using the existing fallback formatting
- **AND** no date tag is shown

#### Scenario: User browses archive
- **WHEN** user expands an archived change
- **THEN** system displays the same file structure as active changes
- **AND** user can select and view archived files
