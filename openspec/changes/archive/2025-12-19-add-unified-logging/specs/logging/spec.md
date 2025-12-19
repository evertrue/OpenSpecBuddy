# Logging Capability

## ADDED Requirements

### Requirement: Log Categories

The system SHALL provide an enumeration of log categories corresponding to application subsystems.

#### Scenario: Categories available for all subsystems
- **WHEN** a developer needs to log an event
- **THEN** they can select from predefined categories: app, ui, fileSystem, parsing, navigation

#### Scenario: Categories are type-safe
- **WHEN** a developer specifies a log category
- **THEN** the category is validated at compile time via enum type

### Requirement: Categorized Logger

The system SHALL provide a `CategorizedLogger` struct that wraps OSLog `Logger` with category support.

#### Scenario: Logger initialization
- **WHEN** a `CategorizedLogger` is initialized with a category
- **THEN** it creates an underlying `Logger` with the app's bundle identifier as subsystem and category name

#### Scenario: Log level support
- **WHEN** logging a message
- **THEN** the logger supports info, debug, error, fault, and default log levels

#### Scenario: Debug build formatting
- **WHEN** logging in a Debug build
- **THEN** messages are logged without modification for Xcode console integration

#### Scenario: Release build formatting
- **WHEN** logging in a Release build
- **THEN** messages are prefixed with `[CATEGORY] [LEVEL]` for readability in exported logs

### Requirement: Static Logger Accessors

The system SHALL extend `Logger` with static properties for convenient access to categorized loggers.

#### Scenario: Static property access
- **WHEN** a developer accesses `Logger.app`, `Logger.ui`, `Logger.fileSystem`, `Logger.parsing`, or `Logger.navigation`
- **THEN** they receive a `CategorizedLogger` configured for that category

#### Scenario: Dynamic category access
- **WHEN** a developer calls `Logger.for(.category)`
- **THEN** they receive a `CategorizedLogger` for the specified category

### Requirement: Signpost Support

The system SHALL provide signpost methods for performance profiling via Instruments.

#### Scenario: Starting a signpost interval
- **WHEN** `startSignpost(name:)` is called
- **THEN** a signpost begin event is recorded and an `OSSignpostID` is returned

#### Scenario: Ending a signpost interval
- **WHEN** `endSignpost(name:signpostID:)` is called with the ID from start
- **THEN** a signpost end event is recorded, completing the interval measurement

#### Scenario: Point-in-time signpost
- **WHEN** `eventSignpost(name:)` is called
- **THEN** a signpost event is recorded for that moment in time

### Requirement: Log Level Descriptions

The system SHALL provide human-readable descriptions for OSLog levels.

#### Scenario: Level description formatting
- **WHEN** a log level is converted to description
- **THEN** it returns uppercase string: INFO, DEBUG, ERROR, FAULT, or DEFAULT
