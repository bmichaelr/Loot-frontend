//
//  GameLog.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import Foundation

class GameLog: ObservableObject {
    private var roundLogIndex: Int = 0
    @Published var roundLogs = [RoundLog]()
    func addMessage(text: String, type: MessageType) {
        if roundLogs.isEmpty { return }
        roundLogs[roundLogIndex].addMessage(text: text, type: type)
    }
    func newRound() {
        if !roundLogs.isEmpty {
            roundLogIndex += 1
        }
        roundLogs.append(RoundLog(roundNumber: roundLogIndex + 1))
    }
    func roundOver(name message: String) {
        roundLogs[roundLogIndex].setWinningMessage(winner: message)
    }
}
