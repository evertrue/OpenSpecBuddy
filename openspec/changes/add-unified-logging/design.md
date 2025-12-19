# Design: Unified Logging with OSLog

## Context

OpenSpecBuddy needs a robust logging infrastructure for debugging, performance profiling, and production diagnostics. Apple's OSLog (unified logging) is the recommended approach for Apple platforms, offering:

- Low overhead (designed for always-on logging)
- Integration with Console.app and Instruments
- Privacy controls for sensitive data
- Log levels with appropriate persistence behavior
- Signpost support for performance profiling

## Goals / Non-Goals

### Goals
- Centralized logging configuration in one location
- Category-based logging for filtering by subsystem
- Consistent API across all logging call sites
- Support for all OSLog levels (debug, info, default, error, fault)
- Signpost support for performance measurement
- Different formatting for Debug vs Release builds

### Non-Goals
- Remote logging or crash reporting (use dedicated services)
- Log file persistence beyond system defaults
- Log rotation or management (handled by OS)

## Decisions

### Decision: Use Enum-Based Categories

Each logging category is defined as a case in a `LogCategory` enum. This provides:
- Compile-time safety for category names
- Easy addition of new categories
- Autocomplete support in IDEs
- Single source of truth for category names

**Alternatives considered:**
- String-based categories: More flexible but error-prone, no compile-time checking
- Protocol-based approach: More complex, unnecessary for this use case

### Decision: Wrapper Struct for Logger

A `CategorizedLogger` struct wraps Apple's `Logger` to:
- Embed category in formatted messages (workaround for OSLogStore limitation)
- Provide consistent log method signatures
- Support signpost operations via `OSLog` instance
- Handle Debug vs Release formatting differences

**Alternatives considered:**
- Direct Logger extension only: Cannot embed category in messages
- Subclassing: Logger is a struct, cannot subclass

### Decision: Static Logger Properties

Provide `Logger.category` static properties (e.g., `Logger.app`, `Logger.parsing`) for:
- Minimal typing at call sites
- Discoverability via autocomplete
- Consistency with Apple's Logger patterns

### Decision: Log Categories

Initial categories based on application subsystems:

| Category | Purpose |
|----------|---------|
| `app` | App lifecycle, general events |
| `ui` | View rendering, UI state changes |
| `fileSystem` | File access, directory operations |
| `parsing` | Markdown and OpenSpec parsing |
| `navigation` | Navigation state, route changes |

### Decision: Debug vs Release Formatting

- **Debug builds**: Use standard Logger formatting (Xcode console integration)
- **Release builds**: Prepend `[CATEGORY] [LEVEL]` to messages for readability when retrieving logs from users

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Category proliferation | Review categories periodically; keep focused on subsystems |
| Performance in hot paths | OSLog is designed for high-frequency logging; debug level disabled in Release |
| Privacy leaks in logs | Use `.private` modifier for sensitive data; default messages are public |

## File Structure

```
OpenSpecBuddy/
└── Infrastructure/
    └── Logging/
        └── Logger+Categories.swift
```

## Usage Examples

```swift
// Simple logging
Logger.app.info("Application launched")
Logger.fileSystem.error("Failed to read directory: \(path)")
Logger.parsing.debug("Parsing markdown file")

// Dynamic category
Logger.for(.navigation).info("Navigated to spec view")

// Signposts for performance
let id = Logger.parsing.startSignpost(name: "ParseMarkdown")
// ... parsing work ...
Logger.parsing.endSignpost(name: "ParseMarkdown", signpostID: id)
```

## Open Questions

None at this time.
