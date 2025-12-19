# Tasks: Add Initial OpenSpec Viewer

## 1. Project Setup
- [ ] 1.1 Add swift-markdown package dependency via SPM
- [ ] 1.2 Create folder structure (Models/, Services/, ViewModels/, Views/)
- [ ] 1.3 Configure app entitlements for file system access

## 2. Data Models
- [ ] 2.1 Create `OpenSpecDirectory` model (root container)
- [ ] 2.2 Create `Spec` model (capability with spec.md and optional design.md)
- [ ] 2.3 Create `Change` model (proposal, tasks, design, spec deltas)
- [ ] 2.4 Create `ArchivedChange` model (completed changes)
- [ ] 2.5 Create `SidebarItem` enum for navigation state

## 3. Services Layer
- [ ] 3.1 Create `DirectoryScanner` service to scan OpenSpec directories
- [ ] 3.2 Create `RecentDirectoriesService` for UserDefaults persistence
- [ ] 3.3 Create `SecurityScopedBookmarkService` for sandbox-safe directory access

## 4. ViewModel
- [ ] 4.1 Create `AppViewModel` with @Observable macro
- [ ] 4.2 Implement directory loading and state management
- [ ] 4.3 Implement selection state for sidebar navigation

## 5. Views - Directory Selection
- [ ] 5.1 Create welcome view for when no directory is open
- [ ] 5.2 Implement directory picker using NSOpenPanel
- [ ] 5.3 Create recent directories list component
- [ ] 5.4 Add "Open Directory" menu item and toolbar button

## 6. Views - Sidebar Navigation
- [ ] 6.1 Update ContentView to use NavigationSplitView
- [ ] 6.2 Create SidebarView with collapsible sections
- [ ] 6.3 Create SpecsSection with capability tree
- [ ] 6.4 Create ChangesSection with active changes tree
- [ ] 6.5 Create ArchiveSection with archived changes tree

## 7. Views - Detail Display
- [ ] 7.1 Create DetailView container for selected content
- [ ] 7.2 Create MarkdownView for rendering markdown content
- [ ] 7.3 Style code blocks with monospace font and background
- [ ] 7.4 Handle empty/loading states

## 8. Integration & Polish
- [ ] 8.1 Wire up sidebar selection to detail view
- [ ] 8.2 Add keyboard shortcuts (Cmd+O for open)
- [ ] 8.3 Persist and restore recent directories on app launch
- [ ] 8.4 Add error handling for invalid/missing directories

## 9. Testing
- [ ] 9.1 Write unit tests for DirectoryScanner
- [ ] 9.2 Write unit tests for data models
- [ ] 9.3 Test with real OpenSpec directories
