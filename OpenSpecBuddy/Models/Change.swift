//
//  Change.swift
//  OpenSpecBuddy
//

import Foundation

struct SpecDelta: Identifiable, Hashable {
    var id: String { specName }
    let specName: String
    let url: URL
    var content: String?
}

struct Change: Identifiable, Hashable {
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

    var hasDesign: Bool {
        design != nil
    }

    var hasTasks: Bool {
        tasks != nil
    }
}
