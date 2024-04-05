//
//  PlayerView.swift
//  Loot
//
//  Created by Joshua on 4/1/24.
//

import Foundation
import SwiftUI
struct PlayerView: View {
    @ObservedObject var gamePlayer: GamePlayer
    @ObservedObject var game: GameState
    @State var scale = CGSize(width: 0, height: 0)
    let localPlayer: Bool
    let namespace: Namespace.ID
    @State var playCardMenu: Bool = false
    @StateObject var layout: PlayCardLayout = PlayCardLayout()
    var body: some View {
        ZStack {
            let playCardView = PlayCardView(layout: layout, players: game.gamePlayers)
            if localPlayer {
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        HandView(hand: gamePlayer.playerPlayedCards, namespace: namespace) { card in }
                        HandView(hand: gamePlayer.playerHand, namespace: namespace) { card in
                            playCardMenu.toggle()
                            playCardView.layout.card = card
                            if gamePlayer.isCurrentTurn {
                                // game.playCard(gamePlayer: gamePlayer, card: card)
                                // game.animationHandler.playCard(player: gamePlayer, card: card)
                                playCardMenu.toggle()
                            }
                        }
                    }
                }.position(gamePlayer.position)
                .border(gamePlayer.isCurrentTurn ? .white : .clear)
            } else {
                HStack {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill()
                                .scaledToFill()
                            Image("loot_\(Int.random(in: 1..<8))").resizable()
                                .scaledToFit()
                            Text(gamePlayer.player.name).font(.caption)
                                .foregroundStyle(.white)
                                .offset(y: 20)
                        }.frame(width: 30, height: 30)
                    } .frame(alignment: .leading)
                    HStack(spacing: 10) {
                        HandView(hand: gamePlayer.playerHand, namespace: namespace) { card in
                        }
                        HandView(hand: gamePlayer.playerPlayedCards, namespace: namespace) { card in
                        }
                    }
                }.border(gamePlayer.isCurrentTurn ? .white : .clear)
            }
            if playCardMenu { playCardView}
        }
    }
}

class PlayCardLayout: ObservableObject {
    @Published var card: Card
    @Published var pickedPlayer: GamePlayer?
    init(card: Card) {
        self.card = card
    }
    init() {
        self.card = Card(power: 0, faceDown: false)
    }
}

struct PlayCardView: View {
    // Take:
    // what card is being played, all the players, round that are not out, card options (only for potted)
    @ObservedObject var layout: PlayCardLayout
    @State var players: [GamePlayer]
    var body: some View {
        ZStack {
            VStack {
                Text("Playing: \(layout.card.power)")
                    .font(.custom("Quasimodo", size: 28))
                    .foregroundStyle(Color.lootBeige)
                    .padding([.leading, .trailing, .top], 20)
                Divider()
                    .frame(height: 1)
                    .background(Color.black)
                VStack {
                    if layout.card.type == .guessing || layout.card.type == .targeted {
                        HStack {
                            Text("Player:")
                        }
                        if layout.card.type == .guessing {
                            HStack {
                                Text("Card: (pick card)")
                            }
                        }
                    }
                }
                    .font(.custom("Quasimodo", size: 18))
                    .foregroundStyle(Color.lootBeige)
                    .multilineTextAlignment(.center)
                    .padding()
                HStack {
                    CustomButton(text: "Cancel", onClick: {}, buttonColor: Color.red)
                    CustomButton(text: "Play", onClick: {})
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.lootBrown)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .padding(30)
        }
    }
}
    
//    #Preview(body: {
//        PlayCardView()
//    })
