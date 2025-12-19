//
//  SidebarView.swift
//  OpenSpecBuddy
//

import SwiftUI

struct SidebarView: View {
    @Environment(AppViewModel.self) private var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        List(selection: $viewModel.selectedItem) {
            if let directory = viewModel.currentDirectory {
                if !directory.specs.isEmpty {
                    SpecsSection(specs: directory.specs)
                }

                if !directory.changes.isEmpty {
                    ChangesSection(changes: directory.changes)
                }

                if !directory.archivedChanges.isEmpty {
                    ArchiveSection(archivedChanges: directory.archivedChanges)
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 220)
    }
}

struct SpecsSection: View {
    let specs: [Spec]
    @Environment(AppViewModel.self) private var viewModel
    @State private var expandedSpecs: Set<String> = []

    var body: some View {
        Section("Specs") {
            ForEach(specs) { spec in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedSpecs.contains(spec.id) },
                        set: { isExpanded in
                            if isExpanded {
                                expandedSpecs.insert(spec.id)
                            } else {
                                expandedSpecs.remove(spec.id)
                            }
                        }
                    )
                ) {
                    NavigationLink(value: SidebarItem.spec(spec, file: .spec)) {
                        Label("spec.md", systemImage: "doc.text")
                    }
                    if spec.hasDesign {
                        NavigationLink(value: SidebarItem.spec(spec, file: .design)) {
                            Label("design.md", systemImage: "doc.text")
                        }
                    }
                } label: {
                    Label(spec.displayName, systemImage: "book.closed")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if expandedSpecs.contains(spec.id) {
                                expandedSpecs.remove(spec.id)
                            } else {
                                expandedSpecs.insert(spec.id)
                                viewModel.selectedItem = .spec(spec, file: .spec)
                            }
                        }
                }
            }
        }
    }
}

struct ChangesSection: View {
    let changes: [Change]
    @Environment(AppViewModel.self) private var viewModel
    @State private var expandedChanges: Set<String> = []

    var body: some View {
        Section("Changes") {
            ForEach(changes) { change in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedChanges.contains(change.id) },
                        set: { isExpanded in
                            if isExpanded {
                                expandedChanges.insert(change.id)
                            } else {
                                expandedChanges.remove(change.id)
                            }
                        }
                    )
                ) {
                    if change.proposal != nil {
                        NavigationLink(value: SidebarItem.change(change, file: .proposal)) {
                            Label("proposal.md", systemImage: "doc.text")
                        }
                    }
                    if change.hasTasks {
                        NavigationLink(value: SidebarItem.change(change, file: .tasks)) {
                            Label("tasks.md", systemImage: "checklist")
                        }
                    }
                    if change.hasDesign {
                        NavigationLink(value: SidebarItem.change(change, file: .design)) {
                            Label("design.md", systemImage: "doc.text")
                        }
                    }
                    ForEach(change.specDeltas) { delta in
                        NavigationLink(value: SidebarItem.change(change, file: .specDelta(delta.specName))) {
                            Label(delta.specName, systemImage: "arrow.triangle.branch")
                        }
                    }
                } label: {
                    Label(change.displayName, systemImage: "pencil.and.outline")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if expandedChanges.contains(change.id) {
                                expandedChanges.remove(change.id)
                            } else {
                                expandedChanges.insert(change.id)
                                // Select proposal as the default file for changes
                                if change.proposal != nil {
                                    viewModel.selectedItem = .change(change, file: .proposal)
                                }
                            }
                        }
                }
            }
        }
    }
}

struct ArchiveSection: View {
    let archivedChanges: [ArchivedChange]
    @Environment(AppViewModel.self) private var viewModel
    @State private var expandedArchived: Set<String> = []

    var body: some View {
        Section("Archive") {
            ForEach(archivedChanges) { archived in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expandedArchived.contains(archived.id) },
                        set: { isExpanded in
                            if isExpanded {
                                expandedArchived.insert(archived.id)
                            } else {
                                expandedArchived.remove(archived.id)
                            }
                        }
                    )
                ) {
                    if archived.proposal != nil {
                        NavigationLink(value: SidebarItem.archivedChange(archived, file: .proposal)) {
                            Label("proposal.md", systemImage: "doc.text")
                        }
                    }
                    if archived.tasks != nil {
                        NavigationLink(value: SidebarItem.archivedChange(archived, file: .tasks)) {
                            Label("tasks.md", systemImage: "checklist")
                        }
                    }
                    if archived.design != nil {
                        NavigationLink(value: SidebarItem.archivedChange(archived, file: .design)) {
                            Label("design.md", systemImage: "doc.text")
                        }
                    }
                    ForEach(archived.specDeltas) { delta in
                        NavigationLink(value: SidebarItem.archivedChange(archived, file: .specDelta(delta.specName))) {
                            Label(delta.specName, systemImage: "arrow.triangle.branch")
                        }
                    }
                } label: {
                    Label(archived.displayName, systemImage: "archivebox")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if expandedArchived.contains(archived.id) {
                                expandedArchived.remove(archived.id)
                            } else {
                                expandedArchived.insert(archived.id)
                                // Select proposal as the default file for archived changes
                                if archived.proposal != nil {
                                    viewModel.selectedItem = .archivedChange(archived, file: .proposal)
                                }
                            }
                        }
                }
            }
        }
    }
}
