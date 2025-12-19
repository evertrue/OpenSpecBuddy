//
//  DetailView.swift
//  OpenSpecBuddy
//

import SwiftUI
import OSLog

struct DetailView: View {
    @Environment(AppViewModel.self) private var viewModel

    var body: some View {
        Group {
            if let selectedItem = viewModel.selectedItem {
                if let content = selectedItem.content {
                    VStack(spacing: 0) {
                        if let changeId = selectedItem.changeId {
                            ChangeContextHeader(changeId: changeId)
                        }
                        MarkdownView(content: content)
                    }
                } else {
                    ContentUnavailableView(
                        "No Content",
                        systemImage: "doc.text",
                        description: Text("This file has no content.")
                    )
                }
            } else {
                ContentUnavailableView(
                    "Select an Item",
                    systemImage: "sidebar.left",
                    description: Text("Choose a spec, change, or archived item from the sidebar.")
                )
            }
        }
        .frame(minWidth: 400)
        .onChange(of: viewModel.selectedItem) { oldValue, newValue in
            if let item = newValue {
                Logger.navigation.info("Selected: \(item.displayName)")
            }
        }
    }
}
