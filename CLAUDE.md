<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

## Development Preferences

### SwiftUI First
- **Prefer SwiftUI over AppKit** whenever possible
- Use `.fileImporter()` modifier instead of NSOpenPanel for file/folder picking
- Avoid importing AppKit unless absolutely necessary
- If AppKit is needed, document why in code comments

## Xcode Project Notes

### File Management
- This project uses **PBXFileSystemSynchronizedRootGroup** (Xcode 16+) - files placed in the `OpenSpecBuddy/` folder are **automatically discovered** by Xcode
- **Do NOT manually edit project.pbxproj** to add source files - just create them in the right directory
- The project file only needs editing for dependencies, build settings, or entitlements

### Swift Package Dependencies
- Dependencies can be added by editing the project.pbxproj with XCRemoteSwiftPackageReference and XCSwiftPackageProductDependency sections
- Xcode will automatically resolve and link the packages

### App Sandbox & File Access
- App uses sandbox with `ENABLE_USER_SELECTED_FILES = readonly` (set in build settings)
- This allows user-selected directories via NSOpenPanel
- For persisting access across launches, use security-scoped bookmarks with `URL.bookmarkData()` and `URL(resolvingBookmarkData:)`