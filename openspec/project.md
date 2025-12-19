# Project Context

## Purpose
OpenSpecBuddy is a macOS application for viewing and browsing OpenSpec directories. Users can point the app at any directory containing an OpenSpec structure, and it provides a visual interface to browse specs, changes, and archived items with rendered markdown display.

### Goals
- Provide a native macOS experience for viewing OpenSpec project structures
- Allow users to quickly browse and understand specs, proposals, and archived changes
- Render markdown content with proper syntax highlighting
- Support multiple OpenSpec directories/projects

## Tech Stack
- **Platform**: macOS (AppKit/SwiftUI)
- **UI Framework**: SwiftUI
- **Language**: Swift 6
- **Minimum Deployment**: macOS 14.0 (Sonoma)
- **Testing**: Swift Testing framework (`import Testing`)
- **Build System**: Xcode / xcodebuild CLI
- **Package Manager**: Swift Package Manager (SPM)

## Project Conventions

### Code Style
- Follow Swift API Design Guidelines
- Use Swift's modern concurrency (async/await, actors) where appropriate
- Prefer value types (structs) over reference types (classes) when possible
- Use explicit access control modifiers (`private`, `internal`, `public`)
- File naming: PascalCase matching the primary type defined (e.g., `SpecView.swift`)
- Keep files focused and reasonably sized (<300 lines preferred)

### Architecture Patterns
- **MVVM**: Use ViewModels for complex view state and business logic
- **Single Source of Truth**: Use `@Observable` or `@ObservableObject` for shared state
- **Dependency Injection**: Pass dependencies explicitly rather than using singletons
- **Separation of Concerns**: Keep views, models, and services in separate layers
- **File Organization**:
  ```
  OpenSpecBuddy/
  ├── App/              # App entry point
  ├── Models/           # Data models
  ├── Views/            # SwiftUI views
  ├── ViewModels/       # View models (if needed)
  ├── Services/         # File system, parsing services
  └── Utilities/        # Extensions, helpers
  ```

### Testing Strategy
- Use Swift Testing framework (`@Test`, `#expect`, `@Suite`)
- Unit tests for models and services
- UI tests for critical user flows
- Test files mirror source structure in `OpenSpecBuddyTests/`
- Aim for testable code through dependency injection

### Git Workflow
- Main branch: `main`
- Feature branches: `feature/<change-id>` (matching OpenSpec change IDs)
- Commit messages: Conventional commits format
  - `feat:` for new features
  - `fix:` for bug fixes
  - `refactor:` for code changes that don't add features or fix bugs
  - `test:` for test additions/changes
  - `docs:` for documentation
- All significant changes go through OpenSpec proposals first

## Domain Context

### OpenSpec Structure
The app needs to understand and display the OpenSpec directory structure:
```
openspec/
├── project.md              # Project conventions (display as overview)
├── specs/                  # Current truth - what IS built
│   └── [capability]/
│       ├── spec.md         # Requirements and scenarios
│       └── design.md       # Technical patterns
├── changes/                # Proposals - what SHOULD change
│   ├── [change-name]/
│   │   ├── proposal.md     # Why, what, impact
│   │   ├── tasks.md        # Implementation checklist
│   │   ├── design.md       # Technical decisions (optional)
│   │   └── specs/          # Delta changes
│   └── archive/            # Completed changes
```

### Key Concepts
- **Specs**: Represent the current state of implemented features
- **Changes**: Proposals for new features or modifications (pending work)
- **Archive**: Completed changes that have been deployed
- **Deltas**: The difference between current specs and proposed changes

### User Workflows
1. Open/select an OpenSpec directory
2. Browse the tree of specs, changes, and archives
3. Select an item to view its markdown content
4. See rendered markdown with syntax highlighting

## Important Constraints

### Technical Constraints
- macOS only (no iOS/iPadOS support initially)
- Must work with standard OpenSpec directory structures
- File system access requires appropriate sandboxing considerations
- Support read-only viewing (no editing in v1)

### Security Constraints
- App sandbox enabled for Mac App Store compatibility
- User must grant explicit access to directories via file picker
- No network access required for core functionality

## External Dependencies

### First-Party
- SwiftUI (UI framework)
- Foundation (file system access)
- UniformTypeIdentifiers (file type handling)

### Third-Party (Potential)
- Markdown rendering library (TBD - evaluate options like swift-markdown, MarkdownUI)
- Syntax highlighting (may be included with markdown renderer)

### Build Commands
```bash
# Build from command line
xcodebuild -scheme OpenSpecBuddy -configuration Debug build

# Run tests
xcodebuild -scheme OpenSpecBuddy -configuration Debug test

# Build for release
xcodebuild -scheme OpenSpecBuddy -configuration Release build
```
