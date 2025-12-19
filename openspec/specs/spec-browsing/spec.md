# spec-browsing Specification

## Purpose
TBD - created by archiving change add-initial-viewer. Update Purpose after archive.
## Requirements
### Requirement: Split View Layout
The system SHALL display content in a NavigationSplitView with sidebar navigation and detail pane.

#### Scenario: Initial layout displayed
- **WHEN** user opens a valid OpenSpec directory
- **THEN** system displays a split view with sidebar on left and detail pane on right
- **AND** sidebar shows collapsible sections for Specs, Changes, and Archive

#### Scenario: Sidebar collapsed
- **WHEN** user collapses the sidebar
- **THEN** detail pane expands to fill available space
- **AND** user can restore sidebar via toolbar button or drag

### Requirement: Specs Section
The system SHALL display all specs from the `openspec/specs/` directory in a hierarchical tree.

#### Scenario: Specs listed by capability
- **WHEN** OpenSpec directory contains specs
- **THEN** sidebar displays "Specs" section with each capability as a tree item
- **AND** each capability shows its contained files (spec.md, design.md)

#### Scenario: User selects spec file
- **WHEN** user clicks on a spec file (e.g., auth/spec.md)
- **THEN** system loads the file content
- **AND** displays rendered markdown in the detail pane

#### Scenario: Empty specs directory
- **WHEN** OpenSpec directory has no specs
- **THEN** Specs section displays "No specs found" placeholder

### Requirement: Changes Section
The system SHALL display all active changes from the `openspec/changes/` directory (excluding archive).

#### Scenario: Changes listed by change-id
- **WHEN** OpenSpec directory contains active changes
- **THEN** sidebar displays "Changes" section with each change-id as a tree item
- **AND** each change shows its contained files (proposal.md, tasks.md, design.md, specs/)

#### Scenario: User selects change file
- **WHEN** user clicks on a change file (e.g., add-feature/proposal.md)
- **THEN** system loads the file content
- **AND** displays rendered markdown in the detail pane

#### Scenario: Change with spec deltas
- **WHEN** a change contains spec deltas in its specs/ subdirectory
- **THEN** system displays the deltas as nested items under the change
- **AND** user can select individual delta files

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

### Requirement: Welcome State
The system SHALL display a welcome screen when no directory is open.

#### Scenario: App launches without directory
- **WHEN** app launches with no previously opened directory
- **THEN** system displays welcome screen with "Open Directory" button
- **AND** shows list of recent directories if any exist

#### Scenario: User closes directory
- **WHEN** user closes the current directory (if implemented)
- **THEN** system returns to welcome screen

