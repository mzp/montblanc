//
//  ARKitBridge.swift
//  CaptureVision
//
//  Created by mzp on 2/11/24.
//

import ARKit
import os
import RealityKit
import SwiftUI

struct BodyTrackView: UIViewRepresentable {
    static var supported: Bool {
        ARBodyTrackingConfiguration.isSupported
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        context.coordinator.setup(arView: arView)
        return arView
    }

    func updateUIView(_: ARView, context: Context) {
        context.coordinator.update()
    }

    func makeCoordinator() -> ARKitViewCoordinator {
        ARKitViewCoordinator()
    }

    class ARKitViewCoordinator: NSObject, ARSessionDelegate {
        private let activity = Activity(#fileID)
        private let logger = Logger(subsystem: "BodyCapture", category: #fileID)
        override init() {}

        func setup(arView: ARView) {
            activity.active {
                logger.info("\(#function, privacy: .public): start session \(arView.session, privacy: .private)")
                arView.session.delegate = self
            }
        }

        func update() {
            activity.active {
                logger.info("\(#function, privacy: .public)")
            }
        }

        func session(_: ARSession, didUpdate anchors: [ARAnchor]) {
            activity.active {
                logger.info("\(#function, privacy: .public): anchors \(anchors, privacy: .private)")
            }
        }
    }
}
