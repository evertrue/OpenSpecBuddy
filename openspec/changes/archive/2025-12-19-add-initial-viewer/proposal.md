# Change: Add Initial OpenSpec Viewer

## Why
The current app is just the Xcode template with no functionality. Users need a native macOS application to browse and view OpenSpec project structures without relying on command-line tools or text editors. This provides a visual, organized way to understand specs, pending changes, and archived work.

## What Changes
- **Directory Management**: Users can open OpenSpec directories via file picker, and the app remembers recently opened directories for quick access
- **Spec Browsing**: Split-pane interface with a sidebar showing hierarchical tree of specs, changes, and archives organized by type and capability
- **Markdown Display**: Selected items render their markdown content with syntax highlighting in a detail pane

## Impact
- Affected specs: `directory-management`, `spec-browsing`, `markdown-display` (all new)
- Affected code:
  - `OpenSpecBuddyApp.swift` - Add document/window management
  - New `Models/` - Data models for OpenSpec structure
  - New `Services/` - File system scanning and parsing
  - New `Views/` - Sidebar, detail pane, directory picker
