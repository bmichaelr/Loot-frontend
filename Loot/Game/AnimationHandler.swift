//
//  AnimationHandler.swift
//  Loot
//
//  Created by Joshua on 4/1/24.
//

import Foundation
import SwiftUI

struct AnimationHandler {
    func dealCard(card: Card, player: GamePlayer) {
        withAnimation(.spring) {
            player.addToHand(card)
        }
    }
    func dealToAll(playerCardPair: [PlayerCardPair], gamePlayers: [GamePlayer], deck: Hand) {
        for (index, pair) in playerCardPair.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                guard let gamePlayer = gamePlayers.first(where: {$0.player.id == pair.player.id}) else {
                    print("unable to find gamePlayer from playerId when calling dealToAll")
                    return
                }
                let card = Card(from: pair.card)
                deck.cards.append(card)
                dealCard(card: card, player: gamePlayer)
            }
        }
    }
    func sendToPlayer(from player1: GamePlayer, to player2: GamePlayer, card: Card) {
        withAnimation {
            player2.addToHand(player1.removeFromHand(card))
        }
    }
    func playCard(player: GamePlayer, card: Card) {
        withAnimation(.spring(duration: 0.3)) {
            player.addToPlayed(player.removeFromHand(card))
        } completion: {
            withAnimation(.spring(duration: 0.3)) {
                card.faceDown = false
            }
        }
    }
    func flipCard(card: Card) {
        withAnimation {
            card.faceDown.toggle()
        }
    }
    func shuffleDeck(deck: Hand) {
        withAnimation {
            deck.shuffleCards()
        }
    }
    func playerOutOfRound(player: GamePlayer) {
        // TOOD implement
    }
    func showWinner(player: GamePlayer) {
        // TODO implement winner
        withAnimation(.linear(duration: 5)) {
            player.test += 2
        }
    }
}
