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

    var displayName: String {
        id.replacingOccurrences(of: "-", with: " ").capitalized
    }
}
