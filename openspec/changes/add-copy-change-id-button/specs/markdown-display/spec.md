## ADDED Requirements
### Requirement: Change Context Header
The system SHALL display a contextual header above the markdown content when viewing files within a change proposal.

#### Scenario: Header displayed for change files
- **WHEN** user selects any file within a change proposal (proposal, tasks, design, or spec delta)
- **THEN** system displays a header bar above the markdown content
- **AND** header shows the change ID in kebab-case format (e.g., "add-unified-logging")
- **AND** header includes a copy button with an appropriate SF Symbol icon

#### Scenario: Copy button functionality
- **WHEN** user clicks the copy button in the change context header
- **THEN** system copies the change ID to the system clipboard
- **AND** displays visual feedback indicating the copy was successful

#### Scenario: Visual feedback animation
- **WHEN** change ID is copied to clipboard
- **THEN** system shows a brief visual indicator (icon change or text feedback)
- **AND** feedback automatically dismisses after a short duration

#### Scenario: Header not shown for non-change items
- **WHEN** user selects a spec file (not within a change)
- **THEN** system does not display the change context header
