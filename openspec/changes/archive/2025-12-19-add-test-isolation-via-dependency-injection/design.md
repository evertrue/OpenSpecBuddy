## Context

The test suite directly uses production infrastructure (`UserDefaults.standard`), causing test data to leak into the application state. When tests run, they clear and populate the "recently opened directories" storage, which then shows up when users launch the app.

This is a classic testing anti-pattern where business logic is tightly coupled to a specific persistence implementation without any abstraction layer.

## Goals / Non-Goals

### Goals
- Achieve complete test isolation so tests never affect production state
- Maintain clean production code with sensible defaults
- Follow Swift conventions for dependency injection
- Minimize boilerplate and abstraction layers

### Non-Goals
- Creating protocol abstractions for `UserDefaults` (over-engineering for this use case)
- Mocking `FileManager` (temp directories are more reliable)
- Implementing a DI container (constructor injection with defaults is sufficient)

## Decisions

### Decision: Constructor Injection with Default Parameters

Use constructor injection with default parameter values:

```swift
init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
    loadRecent()
}
```

**Rationale**: This pattern keeps production code clean (callers don't need to pass anything) while allowing tests to inject isolated instances.

**Alternatives considered**:
- Protocol-based abstraction: Rejected as over-engineering; `UserDefaults` can be instantiated with isolated suite names
- Property injection: Rejected as it allows mutation after initialization
- DI container: Rejected as unnecessary for 2-3 services

### Decision: Isolated UserDefaults via Suite Names

Tests create isolated `UserDefaults` instances using unique suite names:

```swift
let testDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
```

**Rationale**: This provides true isolation with automatic cleanup when the suite is removed.

### Decision: Keep FileManager Tests with Temp Directories

Continue using real `FileManager` with temporary directories rather than mocking.

**Rationale**:
- File system behavior is complex (permissions, paths, traversal)
- Temp directory operations are fast and deterministic
- Mocking `FileManager` requires implementing a large surface area

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Tests might forget to clean up test suites | Use `defer` blocks in every test that creates isolated defaults |
| Default parameters might hide dependency requirements | Document injectable dependencies in code comments |
| Someone might accidentally use `.standard` in tests | Code review; consider lint rule if it becomes a problem |

## Migration Plan

1. Add constructor parameters to services (backward compatible with defaults)
2. Update tests to use isolated instances
3. Verify no side effects
4. No rollback needed - changes are additive

## Open Questions

None - the approach is straightforward and well-established in Swift testing.
