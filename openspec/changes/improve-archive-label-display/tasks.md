## 1. Model Changes
- [ ] 1.1 Add `archiveDate: Date?` computed property to `ArchivedChange` that parses YYYY-MM-DD prefix
- [ ] 1.2 Add `changeName: String` computed property that extracts the name portion after the date
- [ ] 1.3 Update `displayName` to return the human-readable change name (capitalized, dashes to spaces)

## 2. View Changes
- [ ] 2.1 Create `ArchivedChangeLabel` view component with name and date tag
- [ ] 2.2 Style the date as a secondary tag/badge (smaller font, muted color, rounded background)
- [ ] 2.3 Update `ArchiveSection` to use the new label component

## 3. Testing & Validation
- [ ] 3.1 Test with folder names that follow YYYY-MM-DD pattern
- [ ] 3.2 Test fallback behavior for folder names without date prefix
- [ ] 3.3 Build and verify no compiler errors
