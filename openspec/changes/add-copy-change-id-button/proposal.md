# Change: Add Copy Change ID Button

## Why
When working with OpenSpec changes, users frequently need to reference the change ID (e.g., `add-unified-logging`) for CLI commands or documentation. Currently, users must manually type or navigate to find the ID.

## What Changes
- Add a contextual header bar above the markdown content when viewing files within a change proposal
- Display the change ID with a copy-to-clipboard button
- Provide visual feedback (animation) when the ID is copied

## Impact
- Affected specs: `markdown-display`
- Affected code: `DetailView.swift`, possibly new `ChangeContextHeader.swift` component
