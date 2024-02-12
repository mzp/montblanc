//
//  RootNavigation.swift
//  CaptureVision
//
//  Created by mzp on 2/11/24.
//

import SwiftUI

struct PageItem: Identifiable, Hashable, Equatable {
    var id: String
    var title: LocalizedStringKey
    var content: () -> any View

    var anyView: AnyView {
        return AnyView(erasing: content())
    }

    // MARK: Hashable

    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }

    // MARK: Equatable

    static func == (lhs: PageItem, rhs: PageItem) -> Bool {
        lhs.id == rhs.id
    }
}

struct RootNavigation: View {
    var pages: [PageItem] = [
        PageItem(id: "body-capture", title: "Body Capture") {
            BodyCaptureView()
        },
    ]

    @State var path: [String] = []
    var body: some View {
        NavigationStack(path: $path) {
            List(pages) { page in
                NavigationLink(page.title, value: page.id)
            }.navigationDestination(for: String.self) { id in
                pages.first(where: { $0.id == id })?.anyView
            }
        }
    }
}

#Preview("Test") {
    RootNavigation(
        pages: [
            PageItem(id: "a", title: "Circle") {
                Circle().frame(width: 300, height: 300)
            },
            PageItem(id: "b", title: "Rectangle") {
                Rectangle().frame(width: 300, height: 300)
            },
        ]
    )
}

#Preview("Main") {
    RootNavigation()
}
