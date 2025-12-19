//
//  OpenSpecDirectory.swift
//  OpenSpecBuddy
//

import Foundation

struct ProjectInfo: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let version: String?
}

struct OpenSpecDirectory: Identifiable, Hashable {
    let id: UUID
    let url: URL
    var projectInfo: ProjectInfo?
    var specs: [Spec]
    var changes: [Change]
    var archivedChanges: [ArchivedChange]

    init(url: URL, projectInfo: ProjectInfo? = nil, specs: [Spec] = [], changes: [Change] = [], archivedChanges: [ArchivedChange] = []) {
        self.id = UUID()
        self.url = url
        self.projectInfo = projectInfo
        self.specs = specs
        self.changes = changes
        self.archivedChanges = archivedChanges
    }

    var displayName: String {
        projectInfo?.name ?? url.lastPathComponent
    }
}
