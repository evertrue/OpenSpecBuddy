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

    var body: some View {
        Section("Specs") {
            ForEach(specs) { spec in
                DisclosureGroup {
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
                }
            }
        }
    }
}

struct ChangesSection: View {
    let changes: [Change]

    var body: some View {
        Section("Changes") {
            ForEach(changes) { change in
                DisclosureGroup {
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
                }
            }
        }
    }
}

struct ArchiveSection: View {
    let archivedChanges: [ArchivedChange]

    var body: some View {
        Section("Archive") {
            ForEach(archivedChanges) { archived in
                DisclosureGroup {
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
                }
            }
        }
    }
}
