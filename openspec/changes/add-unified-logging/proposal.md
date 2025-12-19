# Change: Add Unified Logging with OSLog

## Why

The application currently lacks a centralized logging system. As the codebase grows, consistent, categorized logging is essential for debugging, performance profiling, and understanding app behavior. Apple's OSLog provides unified logging that integrates with Console.app and Instruments while being low-overhead and privacy-aware.

## What Changes

- Add new `Infrastructure/Logging/` directory with centralized logging code
- Create `LogCategory` enum defining categories for different app subsystems
- Create `CategorizedLogger` struct wrapping `Logger` with category and level support
- Extend `Logger` with static properties for each category for convenient access
- Include signpost support for performance profiling via Instruments
- Support different log formatting between Debug and Release builds

## Impact

- Affected specs: `specs/logging/spec.md` (new capability)
- Affected code:
  - New file: `OpenSpecBuddy/Infrastructure/Logging/Logger+Categories.swift`
- Dependencies: None (uses only Foundation and OSLog from Apple SDK)
