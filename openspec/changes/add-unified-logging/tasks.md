# Tasks: Add Unified Logging

## 1. Implementation

- [x] 1.1 Create directory structure `OpenSpecBuddy/Infrastructure/Logging/`
- [x] 1.2 Implement `LogCategory` enum with categories for app subsystems
- [x] 1.3 Implement `CategorizedLogger` struct with OSLog integration
- [x] 1.4 Add `Logger` extension with static category accessors
- [x] 1.5 Add signpost support methods to `CategorizedLogger`
- [x] 1.6 Add `OSLogType` description extension for readable log levels

## 2. Integration

- [x] 2.1 Add new files to Xcode project
- [x] 2.2 Verify build succeeds

## 3. Testing

- [x] 3.1 Add unit tests for `CategorizedLogger` initialization
- [x] 3.2 Verify logging works in Console.app during development
