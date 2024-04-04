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
    var body: some View {
        ZStack {
            if localPlayer {
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        HandView(hand: gamePlayer.playerPlayedCards, namespace: namespace) { card in }
                        HandView(hand: gamePlayer.playerHand, namespace: namespace) { card in
                            if gamePlayer.isCurrentTurn {
                                game.playCard(gamePlayer: gamePlayer, card: card)
                                // game.animationHandler.playCard(player: gamePlayer, card: card)
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
        }
    }
}

struct PlayCardView: View {
    // Take:
    // what card is being played, all the players, round that are not out, card options (only for potted)
    var body: some View {
        ZStack {
            VStack {
                Text("Playing: (Card)")
                    .font(.custom("Quasimodo", size: 28))
                    .foregroundStyle(Color.lootBeige)
                    .padding([.leading, .trailing, .top], 20)
                Divider()
                    .frame(height: 1)
                    .background(Color.black)
                VStack {
                    HStack {
                        Text("Player: (pick player)")
                    }
                    HStack {
                        Text("Card: (pick card)")
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
    
    #Preview(body: {
        PlayCardView()
    })
