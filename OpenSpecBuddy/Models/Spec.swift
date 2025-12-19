//
//  Spec.swift
//  OpenSpecBuddy
//

import Foundation

struct Spec: Identifiable, Hashable {
    let id: String
    let url: URL
    var specContent: String?
    var designContent: String?

    var displayName: String {
        id.replacingOccurrences(of: "-", with: " ").capitalized
    }

    var hasDesign: Bool {
        designContent != nil
    }
}
