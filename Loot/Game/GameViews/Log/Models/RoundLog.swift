//
//  RoundLog.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import Foundation

class RoundLog: ObservableObject, Identifiable {
    var id = UUID()
    @Published var roundNumber: Int
    @Published var messages: [Message]
    @Published var winningMessage: String = ""
    init(roundNumber: Int) {
        self.roundNumber = roundNumber
        messages = [Message]()
    }
    func addMessage(text: String, type: MessageType) {
        messages.append(Message(text: text, type: type))
    }
    func setWinningMessage(winner: String) {
        winningMessage = "🎉 \(winner) won the round!"
    }
}
