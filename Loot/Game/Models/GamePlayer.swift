//
//  GamePlayer.swift
//  Loot
//
//  Created by Michael, Ben on 4/9/24.
//

import Foundation
import SwiftUI

class GamePlayer: ObservableObject, Identifiable {
    let id = UUID()
    @Published var hands = [Hand(), Hand()]
    @Published var clientId: UUID
    @Published var name: String
    @Published var isOut: Bool
    @Published var isSafe: Bool
    @Published var playerId: UUID
    @Published var currentTurn: Bool = false
    @Published var numberOfWins: Int = 0
    init(from player: Player) {
        self.clientId = player.id
        self.name = player.name
        self.isOut = player.isOut
        self.isSafe = player.isSafe
        self.playerId = player.id
    }
    func getHand(type: HandType) -> Hand {
        switch type {
        case .discard:
            return hands[1]
        case .holding:
            return hands[0]
        }
    }
    func updatePlayer(with player: Player) {
        withAnimation {
            self.isOut = player.isOut
            self.isSafe = player.isSafe
        }
    }
    func changeTurnStatus() {
        self.currentTurn.toggle()
    }
    func resetBooleans() {
        self.isOut = false
        self.isSafe = false
    }
}
