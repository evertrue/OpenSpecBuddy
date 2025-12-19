# Tasks: Add Unified Logging

## 1. Implementation

- [ ] 1.1 Create directory structure `OpenSpecBuddy/Infrastructure/Logging/`
- [ ] 1.2 Implement `LogCategory` enum with categories for app subsystems
- [ ] 1.3 Implement `CategorizedLogger` struct with OSLog integration
- [ ] 1.4 Add `Logger` extension with static category accessors
- [ ] 1.5 Add signpost support methods to `CategorizedLogger`
- [ ] 1.6 Add `OSLogType` description extension for readable log levels

## 2. Integration

- [ ] 2.1 Add new files to Xcode project
- [ ] 2.2 Verify build succeeds

## 3. Testing

- [ ] 3.1 Add unit tests for `CategorizedLogger` initialization
- [ ] 3.2 Verify logging works in Console.app during development
