//
//  GamePlayer.swift
//  Loot
//
//  Created by Joshua on 4/1/24.
//

import Foundation

class GamePlayer: ObservableObject, Identifiable, Hashable {
    static func == (lhs: GamePlayer, rhs: GamePlayer) -> Bool {
        return true
    }
    @Published var playerHand = Hand()
    @Published var playerPlayedCards = Hand()
    @Published var test: CGFloat = 0
    @Published var isCurrentTurn: Bool
    let id: UUID
    var isLocalPlayer: Bool
    var position: CGPoint = .zero
    let player: Player
    init(from player: Player) {
        self.player  = player
        self.isLocalPlayer = false
        self.isCurrentTurn = false
        self.id = player.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(player.name)
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
    func removeFromPlayed(_ card: Card) -> Card {
        guard let index = playerPlayedCards.cards.firstIndex(where: {$0.id == card.id}) else {
            fatalError("card not found")
        }
        return playerPlayedCards.cards.remove(at: index)
    }
}