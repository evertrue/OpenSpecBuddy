# Tasks: Add Initial OpenSpec Viewer

## 1. Project Setup
- [x] 1.1 Add swift-markdown package dependency via SPM
- [x] 1.2 Create folder structure (Models/, Services/, ViewModels/, Views/)
- [x] 1.3 Configure app entitlements for file system access

## 2. Data Models
- [x] 2.1 Create `OpenSpecDirectory` model (root container)
- [x] 2.2 Create `Spec` model (capability with spec.md and optional design.md)
- [x] 2.3 Create `Change` model (proposal, tasks, design, spec deltas)
- [x] 2.4 Create `ArchivedChange` model (completed changes)
- [x] 2.5 Create `SidebarItem` enum for navigation state

## 3. Services Layer
- [x] 3.1 Create `DirectoryScanner` service to scan OpenSpec directories
- [x] 3.2 Create `RecentDirectoriesService` for UserDefaults persistence
- [x] 3.3 Create `SecurityScopedBookmarkService` for sandbox-safe directory access (integrated into RecentDirectoriesService)

## 4. ViewModel
- [x] 4.1 Create `AppViewModel` with @Observable macro
- [x] 4.2 Implement directory loading and state management
- [x] 4.3 Implement selection state for sidebar navigation

## 5. Views - Directory Selection
- [x] 5.1 Create welcome view for when no directory is open
- [x] 5.2 Implement directory picker using SwiftUI fileImporter (not NSOpenPanel - SwiftUI first approach)
- [x] 5.3 Create recent directories list component
- [x] 5.4 Add "Open Directory" menu item and toolbar button

## 6. Views - Sidebar Navigation
- [x] 6.1 Update ContentView to use NavigationSplitView
- [x] 6.2 Create SidebarView with collapsible sections
- [x] 6.3 Create SpecsSection with capability tree
- [x] 6.4 Create ChangesSection with active changes tree
- [x] 6.5 Create ArchiveSection with archived changes tree

## 7. Views - Detail Display
- [x] 7.1 Create DetailView container for selected content
- [x] 7.2 Create MarkdownView for rendering markdown content
- [x] 7.3 Style code blocks with monospace font and background
- [x] 7.4 Handle empty/loading states

## 8. Integration & Polish
- [x] 8.1 Wire up sidebar selection to detail view
- [x] 8.2 Add keyboard shortcuts (Cmd+O for open)
- [x] 8.3 Persist and restore recent directories on app launch
- [x] 8.4 Add error handling for invalid/missing directories

## 9. Testing
- [x] 9.1 Write unit tests for DirectoryScanner
- [x] 9.2 Write unit tests for data models
- [x] 9.3 Test with real OpenSpec directories
