//
//  GamePlayer.swift
//  Loot
//
//  Created by Joshua on 4/1/24.
//

import Foundation

class GamePlayer: ObservableObject {
    @Published var playerHand = Hand()
    @Published var playerPlayedCards = Hand()
    @Published var test: CGFloat = 0
    @Published var isCurrentTurn: Bool
    var isLocalPlayer: Bool
    var position: CGPoint = .zero
    let player: Player
    init(from player: Player) {
        self.player  = player
        self.isLocalPlayer = false
        self.isCurrentTurn = false
    }
    func addToHand(_ card: Card) {
        playerHand.cards.append(card)
    }
    func addToPlayed(_ card: Card) {
        playerPlayedCards.cards.append(card)
    }
    func removeFromHand(_ card: Card) -> Card {
        guard let index = playerHand.cards.firstIndex(where: {$0.id == card.id}) else {
            fatalError("card not found")
        }
        return playerHand.cards.remove(at: index)
    }
}
