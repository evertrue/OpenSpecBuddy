//
//  ChangeContextHeader.swift
//  OpenSpecBuddy
//

import SwiftUI
import AppKit
import OSLog

struct ChangeContextHeader: View {
    let changeId: String

    @State private var showCopied = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "doc.text")
                .foregroundStyle(.secondary)

            Text("Change:")
                .foregroundStyle(.secondary)

            Text(changeId)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)

            Button {
                copyToClipboard()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                    if showCopied {
                        Text("Copied!")
                    }
                }
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(showCopied ? .green : .accentColor)
            }
            .buttonStyle(.borderless)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor))
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    private func copyToClipboard() {
        Logger.ui.info("Copying change ID to clipboard: \(changeId)")
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(changeId, forType: .string)

        showCopied = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopied = false
            }
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        ChangeContextHeader(changeId: "add-copy-change-id-button")
        Spacer()
    }
}
