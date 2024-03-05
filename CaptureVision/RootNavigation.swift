//
//  RootNavigation.swift
//  CaptureVision
//
//  Created by mzp on 2/11/24.
//

import SwiftUI

struct PageItem: Identifiable, Hashable, Equatable {
    var id: String
    var title: String
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
        PageItem(id: "model-render", title: "Render Model") {
            ModelRenderingView()
        },
    ]

    @AppStorage("RootNavigation.path") var path: String = ""
    var body: some View {
        NavigationStack(path:
            Binding(get: {
                path.components(separatedBy: "/").filter {
                    !$0.isEmpty
                }
            }, set: {
                path = $0.joined(separator: "/")
            })
        ) {
            List(pages) { page in
                NavigationLink(page.title, value: page.id)
            }.navigationDestination(for: String.self) { id in
                if let page = pages.first(where: { $0.id == id }) {
                    page.anyView
                        .navigationTitle(page.title)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

#Preview("Test") {
    RootNavigation(
        pages: [
            PageItem(id: "a", title: String(localized: "Circle", comment: "#Preview")) {
                Circle().frame(width: 300, height: 300)
            },
            PageItem(id: "b", title: String(localized: "Rectangle", comment: "#Preview")) {
                Rectangle().frame(width: 300, height: 300)
            },
        ]
    )
}

#Preview("Main") {
    RootNavigation()
}
