//
//  SceneKitBridge.swift
//  CaptureVision
//
//  Created by mzp on 3/4/24.
//

import SceneKit
import SwiftUI

struct SceneKitView: View {
    @State var scene: SCNScene?
    var body: some View {
        SceneView(scene: scene).onAppear {
            Task { await load() }
        }
    }

    func load() async {
        guard
            let url = Bundle.main.url(forResource: "monkey", withExtension: "scn"),
            let source = SCNSceneSource(url: url)
        else {
            fatalError("Can't load monkey.scn")
        }
        scene = source.scene()

        await MainActor.run {
            let light = SCNLight()
            light.type = .directional
            self.scene?.rootNode.light = light
        }
    }
}

#Preview {
    SceneKitView()
}
