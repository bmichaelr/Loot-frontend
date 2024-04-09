//
//  GamePlayer.swift
//  Loot
//
//  Created by Michael, Ben on 4/9/24.
//

import Foundation

class GamePlayer: ObservableObject, Identifiable {
    let id = UUID()
    @Published var hands = [Hand(), Hand()]
    @Published var clientId: UUID
    @Published var name: String
    @Published var isOut: Bool
    @Published var isSafe: Bool
    @Published var playerId: UUID
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
        self.isOut = player.isOut
        self.isSafe = player.isSafe
    }
}
