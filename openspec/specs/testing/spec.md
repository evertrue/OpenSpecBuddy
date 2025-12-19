# testing Specification

## Purpose
TBD - created by archiving change increase-unit-test-coverage. Update Purpose after archive.
## Requirements
### Requirement: Model Unit Tests
The test suite SHALL include unit tests for all model computed properties and business logic.

#### Scenario: ArchivedChange date parsing
- **WHEN** an ArchivedChange has ID "2024-01-15-add-feature"
- **THEN** archiveDate returns January 15, 2024
- **AND** changeName returns "add-feature"
- **AND** displayName returns "Add Feature"

#### Scenario: ArchivedChange without date prefix
- **WHEN** an ArchivedChange has ID "add-feature" (no date prefix)
- **THEN** archiveDate returns nil
- **AND** changeName returns "add-feature"

#### Scenario: SidebarItem content retrieval
- **WHEN** a SidebarItem wraps a Spec with file type .spec
- **THEN** content returns the spec's specContent

#### Scenario: SidebarItem change ID
- **WHEN** a SidebarItem wraps a Change
- **THEN** changeId returns the Change's id
- **WHEN** a SidebarItem wraps a Spec
- **THEN** changeId returns nil

### Requirement: Service Unit Tests
The test suite SHALL include unit tests for service layer logic that does not require UI interaction.

#### Scenario: DirectoryScanner finds archived changes
- **WHEN** scanning a directory with openspec/changes/archive/ containing archived change folders
- **THEN** archivedChanges array contains the archived changes

#### Scenario: DirectoryScanner loads spec deltas
- **WHEN** scanning a change that has a specs/ subdirectory with capability folders
- **THEN** the change's specDeltas array contains SpecDelta objects

#### Scenario: RecentDirectoriesService manages list
- **WHEN** addRecent is called with a new URL
- **THEN** the directory appears at index 0 of recentDirectories
- **WHEN** addRecent is called with an existing URL
- **THEN** the directory moves to index 0

### Requirement: Enum Unit Tests
The test suite SHALL include unit tests for all enum raw values and display names.

#### Scenario: SpecFile enum values
- **WHEN** accessing SpecFile.spec.rawValue
- **THEN** it returns "spec"
- **WHEN** accessing SpecFile.design.displayName
- **THEN** it returns "Design"

#### Scenario: ChangeFile enum values
- **WHEN** accessing ChangeFile.proposal.rawValue
- **THEN** it returns "proposal"
- **WHEN** accessing ChangeFile.specDelta("auth").rawValue
- **THEN** it returns "delta-auth"

### Requirement: Logger Unit Tests
The test suite SHALL verify logger infrastructure initializes correctly.

#### Scenario: Logger category access
- **WHEN** accessing Logger.app
- **THEN** the category is .app
- **WHEN** accessing Logger.for(.parsing)
- **THEN** the category is .parsing

#### Scenario: All logging levels callable
- **WHEN** calling debug, info, notice, error, fault on a CategorizedLogger
- **THEN** each method executes without error

