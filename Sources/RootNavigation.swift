//
//  RootNavigation.swift
//  CaptureVision
//
//  Created by mzp on 2/11/24.
//

import SwiftUI
import os

struct RootNavigation: View {
    var pages: [PageItem] = [
        PageItem(id: "body-capture", title: "Body Capture") {
            BodyCaptureView()
        },
        PageItem(id: "model-render", title: "Render Model") {
            ModelRenderingNavigation()
        },
        PageItem(id: "debug", title: "Debug", content: {
            DebugView()
        })
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
    RootNavigation(pages: PageItem.previews)
}

#Preview("Main") {
    RootNavigation()
}
