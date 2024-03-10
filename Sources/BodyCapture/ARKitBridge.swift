//
//  ARKitBridge.swift
//  CaptureVision
//
//  Created by mzp on 2/11/24.
//

import ARKit
import Combine
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
        private let activity = Activity("ARKitSession")
        private let logger = Logger(subsystem: #fileID, category: "ApplicationLog")
        override init() {}

        func setup(arView: ARView) {
            activity.active {
                logger.log("\(#function, privacy: .public): start session \(arView.session, privacy: .private)")
                arView.session.delegate = self
                arView.session.delegateQueue = .init(label: #function, qos: .background)
                let configuration = ARBodyTrackingConfiguration()
                arView.session.run(configuration)

                arView.scene.addAnchor(characterAnchor)
                loadCharacter()
            }
        }

        var character: BodyTrackedEntity?
        let characterOffset: SIMD3<Float> = [-1.0, 0, 0]
        let characterAnchor = AnchorEntity()
        func loadCharacter() {
            var cancellable: AnyCancellable? = nil
            cancellable = Entity.loadBodyTrackedAsync(named: "robot").sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error: Unable to load model: \(error.localizedDescription)")
                    }
                    cancellable?.cancel()
            }, receiveValue: { (character: Entity) in
                if let character = character as? BodyTrackedEntity {
                    // Scale the character to human size
                    character.scale = [1.0, 1.0, 1.0]
                    self.character = character
                    cancellable?.cancel()
                } else {
                    print("Error: Unable to load model as BodyTrackedEntity")
                }
            })
        }

        func update() {
            activity.active {
                logger.log("\(#function, privacy: .public)")
            }
        }

        // MARK: - ARSessionObserver
        func session(_ session: ARSession, didFailWithError error: any Error) {
                logger.error("\(#function, privacy: .public): error \(error, privacy: .private)")
        }

        // MARK: - ARSessionDelegate

        func session(_: ARSession, didUpdate anchors: [ARAnchor]) {
            activity.active {
                logger.log("\(#function, privacy: .public): anchors \(anchors, privacy: .private)")
                for anchor in anchors {
                    guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }

                    // Update the position of the character anchor's position.

                    // Update the position of the character anchor's position.
                    let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
                    characterAnchor.position = bodyPosition + characterOffset
                    // Also copy over the rotation of the body anchor, because the skeleton's pose
                    // in the world is relative to the body anchor's rotation.
                    characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation

                    if let character = character, character.parent == nil {
                        // Attach the character to its anchor as soon as
                        // 1. the body anchor was detected and
                        // 2. the character was loaded.
                        characterAnchor.addChild(character)
                    }
                }
            }
        }
    }
}
