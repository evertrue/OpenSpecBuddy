# OpenSpecBuddy Roadmap

Future ideas and enhancements beyond the initial viewer.

## Phase 1: Viewer (Current)
Basic read-only viewing of OpenSpec directories.
- Open and browse OpenSpec directories
- View specs, changes, and archives
- Render markdown with syntax highlighting

## Phase 2: Git Integration
Connect the viewer to Git workflows.

### Branch-Based Change Proposals
- Detect when viewing a Git repository
- Show which branch contains which change proposals
- Compare change proposals between branches (e.g., feature branch vs main)
- Visual diff of spec deltas

### PR Review Workflow
**This is the workflow we're dogfooding right now:**
1. Developer creates change proposal on a feature branch
2. Developer opens PR for the proposal (code not yet written)
3. Reviewer uses OpenSpecBuddy to review the proposal
4. On approval, proposal merges to main
5. Implementation happens in subsequent PRs

The app should facilitate this by:
- Fetching and displaying PRs that contain OpenSpec changes
- Showing proposal diffs in a friendly UI
- One-click to open PR on GitHub for approval
- Filter to show "proposals only" PRs vs "implementation" PRs

## Phase 3: Collaboration Features
- Comments/annotations on specs (stored locally or synced)
- Share links to specific specs/requirements
- Export specs to PDF or HTML

## Phase 4: Editing (Maybe)
- Edit specs directly in the app
- Validate changes in real-time
- Create new change proposals from within the app

## Notes
- Keep the app lightweight and fast
- Native macOS experience is priority
- Read-only viewer is the foundation; editing is optional future scope
