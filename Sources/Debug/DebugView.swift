//
//  LogView.swift
//  Montblanc
//
//  Created by mzp on 3/9/24.
//

import SwiftUI
import os

struct DebugToken {
    var name: String

    static var firstTokens = [
        "Blue",
        "Red",
        "Green",
        "Purple",
        "Yellow",
        "White",
    ]

    static var secondTokens = [
        "Bird",
        "Cat",
        "Dolphin",
        "Rabbit",
        "Lion"
    ]

    static func make() -> DebugToken {
        let first = choice(firstTokens)
        let second = choice(secondTokens)
        return DebugToken(name:"\(first)-\(second)")
    }

    private static func choice<T>(_ array : [T]) -> T {
        let index = Int.random(in: 0 ..< array.count)
        return array[index]
    }
}


struct DebugView: View {
    let logger = Logger(subsystem: "jp.mzp.montblanc", category: "Debug")
    var body: some View {
        Button("Emit") {
            let token = DebugToken.make()
            let activity = Activity("Log Emmition")
            activity.active {
                logger.log("[\(token.name, privacy: .public)] Start")
                let subActivity = Activity("Activity")
                subActivity.active(execute: {
                logger.log("[\(token.name, privacy: .public)] Nested Start")
                logger.log("[\(token.name, privacy: .public)] Nested End")
                })
                logger.log("[\(token.name, privacy: .public)] End")
            }
        }
    }
}

#Preview {
    DebugView()
}
