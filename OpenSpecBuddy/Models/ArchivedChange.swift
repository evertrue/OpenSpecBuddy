//
//  ArchivedChange.swift
//  OpenSpecBuddy
//

import Foundation

struct ArchivedChange: Identifiable, Hashable {
    let id: String
    let url: URL
    var proposal: String?
    var tasks: String?
    var design: String?
    var specDeltas: [SpecDelta]

    init(id: String, url: URL, proposal: String? = nil, tasks: String? = nil, design: String? = nil, specDeltas: [SpecDelta] = []) {
        self.id = id
        self.url = url
        self.proposal = proposal
        self.tasks = tasks
        self.design = design
        self.specDeltas = specDeltas
    }

    /// The archive date extracted from the YYYY-MM-DD prefix of the folder name, if present
    var archiveDate: Date? {
        // Pattern: YYYY-MM-DD-change-name
        let pattern = /^(\d{4})-(\d{2})-(\d{2})-/
        guard let match = id.firstMatch(of: pattern) else {
            return nil
        }

        let year = Int(match.1) ?? 0
        let month = Int(match.2) ?? 0
        let day = Int(match.3) ?? 0

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return Calendar.current.date(from: components)
    }

    /// The change name portion after the YYYY-MM-DD prefix, or the full id if no prefix
    var changeName: String {
        let pattern = /^\d{4}-\d{2}-\d{2}-/
        if let match = id.firstMatch(of: pattern) {
            return String(id[match.range.upperBound...])
        }
        return id
    }

    /// Human-readable display name (capitalized, dashes to spaces)
    var displayName: String {
        changeName.replacingOccurrences(of: "-", with: " ").capitalized
    }
}
