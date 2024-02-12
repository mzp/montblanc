//
//  App.swift
//  CaptureVision
//
//  Created by mzp on 2/11/24.
//

import SwiftUI

@main
struct CaptureVisionApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    var body: some View {
        BodyCaptureView()
    }
}

#Preview {
    RootView()
}
