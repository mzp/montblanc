//
//  BodyCaptureView.swift
//  CaptureVision
//
//  Created by mzp on 2/11/24.
//
import SwiftUI

struct BodyCaptureView: View {
    var body: some View {
        if BodyTrackView.supported {
            BodyTrackView()
        } else {
            Text("Not supported in this device")
        }
    }
}

#Preview {
    BodyCaptureView()
}
