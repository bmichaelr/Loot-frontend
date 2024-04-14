//
//  Message.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import Foundation
import SwiftUI

struct Message: Identifiable, Hashable {
    let id = UUID()
    var text: String
    var type: MessageType
    static func createExampleMessages() -> [Message] {
        return [
            Message(text: "It is now Josh's turn", type: .turnUpdate),
            Message(text: "Josh played the wishing ring.", type: .cardPlayed),
            Message(text: "It is not Ben's turn", type: .turnUpdate),
            Message(text: "Ben played potted plant, he guessed maul rat on Josh and was rong.", type: .cardPlayed),
            Message(text: "It is now Josh's turn", type: .turnUpdate),
            Message(text: "Josh played Net Troll on Ben. Ben is out!", type: .cardPlayed),
            Message(text: "Round is over", type: .roundOver)
        ]
    }
}

enum MessageType {
    case turnUpdate
    case cardPlayed
    case roundOver
    func getColor() -> Color {
        switch self {
        case .turnUpdate:
            return Color.blue
        case .roundOver:
            return Color.red
        case .cardPlayed:
            return Color.green
        }
    }
    func getImage() -> String {
        switch self {
        case .turnUpdate:
            return "arrowshape.turn.up.right.fill"
        case .roundOver:
            return "stop.fill"
        case .cardPlayed:
            return "arrow.turn.up.forward.iphone.fill"
        }
    }
}
