//
//  SettingsView.swift
//  OpenSpecBuddy
//

import SwiftUI
import OSLog

struct SettingsView: View {
    @Environment(AppViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showClearConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            Form {
                Section("Recent Directories") {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Clear Recent Directories")
                            Text("Remove all items from the recent directories list")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Clear") {
                            showClearConfirmation = true
                        }
                        .disabled(viewModel.recentDirectories.isEmpty)
                    }
                }
            }
            .formStyle(.grouped)

            Divider()

            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(width: 450, height: 200)
        .alert("Clear Recent Directories?", isPresented: $showClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                Logger.ui.info("Clearing recent directories from settings")
                viewModel.clearRecentDirectories()
            }
        } message: {
            Text("This will remove all items from your recent directories list. This action cannot be undone.")
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppViewModel())
}
