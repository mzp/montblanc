//
//  ModelNavigation.swift
//  CaptureVision
//
//  Created by mzp on 3/3/24.
//

import SwiftUI

struct ModelRenderingNavigation: View {
    var pages: [PageItem]

    @State
    var selection: String

    init(pages: [PageItem] = [
        PageItem(id: "scenekit", title: "Suzanne") {
            SceneKitView()
        },
    ]) {
        self.pages = pages
        selection = pages.first?.id ?? ""
    }

    var body: some View {
        VStack {
            if let page = pages.first(where: { $0.id == selection }) {
                page.anyView.ignoresSafeArea()
            }
            Spacer()
            Picker("Type of scene", selection: $selection) {
                ForEach(pages) { page in
                    Text(page.title).tag(page.id)
                }
            }.pickerStyle(.segmented)
                .padding()
        }
    }
}

#Preview {
    ModelRenderingNavigation(pages: PageItem.previews)
}

#Preview {
    ModelRenderingNavigation()
}
