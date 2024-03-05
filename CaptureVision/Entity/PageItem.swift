//
//  PageItem.swift
//  CaptureVision
//
//  Created by mzp on 3/4/24.
//

import SwiftUI

struct PageItem: Identifiable, Hashable, Equatable {
    var id: String
    var title: String
    var content: () -> any View

    var anyView: AnyView {
        return AnyView(erasing: content())
    }

    static let previews: [PageItem] = [
        .init(id: "a", title: String(localized: "Circle", comment: "#Preview")) {
            Circle().frame(width: 300, height: 300)
        },
        .init(id: "b", title: String(localized: "Rectangle", comment: "#Preview")) {
            Rectangle().frame(width: 300, height: 300)
        },
    ]

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }

    // MARK: Equatable

    static func == (lhs: PageItem, rhs: PageItem) -> Bool {
        lhs.id == rhs.id
    }
}
