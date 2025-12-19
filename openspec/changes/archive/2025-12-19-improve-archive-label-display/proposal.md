# Change: Improve Archive Label Display

## Why
Archived changes display as "2025 12 19 Add Initial Viewer" which is hard to read. The date portion isn't visually distinct from the change name, making it difficult to quickly scan and identify changes.

## What Changes
- Parse archive folder names to extract date and change name components
- Display change name as the primary label (e.g., "Add Initial Viewer")
- Show archive date as a visually distinct tag/badge (e.g., styled secondary text)
- Handle edge cases where folder names don't follow YYYY-MM-DD prefix pattern

## Impact
- Affected specs: `spec-browsing` (Archive Section requirement)
- Affected code:
  - `ArchivedChange.swift` - Add parsed date and formatted name properties
  - `SidebarView.swift` - Update ArchiveSection to use new label format with date tag
