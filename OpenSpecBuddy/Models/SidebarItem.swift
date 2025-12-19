//
//  SidebarItem.swift
//  OpenSpecBuddy
//

import Foundation

enum SidebarItem: Hashable, Identifiable {
    case spec(Spec, file: SpecFile)
    case change(Change, file: ChangeFile)
    case archivedChange(ArchivedChange, file: ChangeFile)

    var id: String {
        switch self {
        case .spec(let spec, let file):
            return "spec-\(spec.id)-\(file.rawValue)"
        case .change(let change, let file):
            return "change-\(change.id)-\(file.rawValue)"
        case .archivedChange(let archived, let file):
            return "archived-\(archived.id)-\(file.rawValue)"
        }
    }

    var displayName: String {
        switch self {
        case .spec(let spec, _):
            return spec.displayName
        case .change(let change, _):
            return change.displayName
        case .archivedChange(let archived, _):
            return archived.displayName
        }
    }

    var content: String? {
        switch self {
        case .spec(let spec, let file):
            switch file {
            case .spec: return spec.specContent
            case .design: return spec.designContent
            }
        case .change(let change, let file):
            switch file {
            case .proposal: return change.proposal
            case .tasks: return change.tasks
            case .design: return change.design
            case .specDelta(let name):
                return change.specDeltas.first { $0.specName == name }?.content
            }
        case .archivedChange(let archived, let file):
            switch file {
            case .proposal: return archived.proposal
            case .tasks: return archived.tasks
            case .design: return archived.design
            case .specDelta(let name):
                return archived.specDeltas.first { $0.specName == name }?.content
            }
        }
    }
}

enum SpecFile: Hashable {
    case spec
    case design

    var rawValue: String {
        switch self {
        case .spec: return "spec"
        case .design: return "design"
        }
    }

    var displayName: String {
        switch self {
        case .spec: return "Spec"
        case .design: return "Design"
        }
    }
}

enum ChangeFile: Hashable {
    case proposal
    case tasks
    case design
    case specDelta(String)

    var rawValue: String {
        switch self {
        case .proposal: return "proposal"
        case .tasks: return "tasks"
        case .design: return "design"
        case .specDelta(let name): return "delta-\(name)"
        }
    }

    var displayName: String {
        switch self {
        case .proposal: return "Proposal"
        case .tasks: return "Tasks"
        case .design: return "Design"
        case .specDelta(let name): return name
        }
    }
}
