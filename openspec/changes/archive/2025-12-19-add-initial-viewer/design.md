# Design: Initial OpenSpec Viewer

## Context
Building a native macOS viewer for OpenSpec directories. The app needs to scan file system structures, parse markdown files, and present them in an organized UI. This is a greenfield project starting from the Xcode SwiftUI template.

## Goals / Non-Goals

### Goals
- Native macOS experience using SwiftUI
- Fast directory scanning and lazy loading of content
- Clean separation between file system operations and UI
- Remember user preferences (recent directories)
- Render markdown with syntax highlighting

### Non-Goals
- Editing specs or changes (read-only viewer)
- Running OpenSpec CLI commands from the app
- Real-time file watching (manual refresh for v1)
- Cross-platform support (macOS only)

## Decisions

### Architecture: MVVM with @Observable
**Decision**: Use MVVM pattern with Swift's `@Observable` macro for state management.

**Rationale**:
- `@Observable` is the modern SwiftUI approach (macOS 14+)
- Simpler than `@ObservableObject` with `@Published`
- Clean separation: Views observe ViewModels, ViewModels use Services

**Alternatives considered**:
- TCA (The Composable Architecture) - Too heavy for initial version
- Plain SwiftUI with `@State` only - Insufficient for shared state

### File Organization
```
OpenSpecBuddy/
├── App/
│   └── OpenSpecBuddyApp.swift
├── Models/
│   ├── OpenSpecDirectory.swift    # Root directory model
│   ├── Spec.swift                 # Spec capability model
│   ├── Change.swift               # Change proposal model
│   └── ArchivedChange.swift       # Archived change model
├── Services/
│   ├── DirectoryScanner.swift     # File system scanning
│   ├── MarkdownParser.swift       # Markdown processing
│   └── RecentDirectories.swift    # UserDefaults persistence
├── ViewModels/
│   └── AppViewModel.swift         # Main app state
└── Views/
    ├── ContentView.swift          # Main split view
    ├── Sidebar/
    │   ├── SidebarView.swift      # Navigation sidebar
    │   ├── SpecsSection.swift     # Specs tree
    │   ├── ChangesSection.swift   # Changes tree
    │   └── ArchiveSection.swift   # Archive tree
    ├── Detail/
    │   ├── DetailView.swift       # Content display
    │   └── MarkdownView.swift     # Rendered markdown
    └── Components/
        └── DirectoryPicker.swift  # Open folder UI
```

### Data Models
**Decision**: Use value types (structs) with `Identifiable` conformance.

```swift
struct OpenSpecDirectory: Identifiable {
    let id: UUID
    let url: URL
    let projectInfo: ProjectInfo?
    var specs: [Spec]
    var changes: [Change]
    var archivedChanges: [ArchivedChange]
}

struct Spec: Identifiable {
    let id: String  // capability name
    let url: URL
    let specContent: String?
    let designContent: String?
}

struct Change: Identifiable {
    let id: String  // change-id
    let url: URL
    let proposal: String?
    let tasks: String?
    let design: String?
    var specDeltas: [SpecDelta]
}
```

### Markdown Rendering
**Decision**: Use Apple's swift-markdown for parsing, AttributedString for rendering.

**Rationale**:
- First-party Apple library, well-maintained
- Integrates with SwiftUI's `Text` view via `AttributedString`
- Supports code block syntax highlighting with additional work

**Alternatives considered**:
- MarkdownUI (third-party) - More features but adds dependency
- WKWebView with markdown.js - Not native, heavier

**Implementation**:
- Parse markdown to AST using swift-markdown
- Convert to `AttributedString` with custom styling
- Code blocks get monospace font and background color

### State Persistence
**Decision**: Use `@AppStorage` and `UserDefaults` for recent directories.

**Rationale**:
- Simple, built-in solution
- Sufficient for storing list of recent directory paths
- No need for Core Data or SQLite for this use case

**Data stored**:
- Recent directory URLs (up to 10)
- Last opened directory
- Window state (handled by SwiftUI)

### Navigation Model
**Decision**: Use `NavigationSplitView` with three-column layout.

```
┌─────────────┬──────────────────┬─────────────────────────┐
│   Sidebar   │   Content List   │     Detail View         │
│             │                  │                         │
│ ▼ Specs     │ • spec.md        │  # Authentication       │
│   auth      │ • design.md      │                         │
│   checkout  │                  │  ## Purpose             │
│             │                  │  Handle user login...   │
│ ▼ Changes   │                  │                         │
│   add-2fa   │                  │  ## Requirements        │
│             │                  │  ...                    │
│ ▼ Archive   │                  │                         │
│   2024-...  │                  │                         │
└─────────────┴──────────────────┴─────────────────────────┘
```

## Risks / Trade-offs

### Risk: Large directories slow to scan
**Mitigation**: Scan directory structure first, load file content lazily on selection.

### Risk: Complex markdown not rendering correctly
**Mitigation**: Start with basic rendering, iterate. Tables and complex formatting can be enhanced later.

### Risk: Sandbox restrictions for file access
**Mitigation**: Use `NSOpenPanel` for user-initiated access, store security-scoped bookmarks for recent directories.

## Open Questions

1. Should we support multiple open directories simultaneously (tabs)?
   - **Recommendation**: Start with single directory, add tabs later if needed

2. How to handle malformed OpenSpec directories?
   - **Recommendation**: Show partial content with warnings, don't fail completely

3. Should spec deltas show diff view or just content?
   - **Recommendation**: Show content for v1, consider diff view in future
