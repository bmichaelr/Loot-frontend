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
            let playCardView = PlayCardView(layout: layout, players: game.gamePlayers, toggle: $playCardMenu, game: game, player: gamePlayer)
            if localPlayer {
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        HandView(hand: gamePlayer.playerPlayedCards, namespace: namespace) { card in }
                        HandView(hand: gamePlayer.playerHand, namespace: namespace) { card in
                            if gamePlayer.isCurrentTurn {
                                playCardView.layout.card = card
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
    @Published var pickedPlayerString: String = ""
    @Published var pickedCard: Card?
    let cardNames: [String] = ["Potted Plant", "Maul Rat", "Duck of Doom", "Wishing Ring", "Net Troll", "Gazebo", "Dragon", "Loot"]
    init(card: Card) {
        self.card = card
    }
    init() {
        self.card = Card(power: 0, faceDown: false)
        self.pickedPlayer = GamePlayer(from: Player(name: "", id: UUID()))
        self.pickedCard = Card(from: CardResponse(power: 0, name: "", description: ""))
    }
}

struct PlayCardView: View {
    // Take:
    // what card is being played, all the players, round that are not out, card options (only for potted)
    @StateObject var layout: PlayCardLayout
    @State var players: [GamePlayer]
    @State var fieldValuePlayer: String = ""
    @State var fieldValueCard: String = ""
    @Binding var toggle: Bool
    @ObservedObject var game: GameState
    @ObservedObject var player: GamePlayer
    var body: some View {
        ZStack {
            VStack {
                Text("Playing: \(layout.card.name)")
                    .font(.custom("Quasimodo", size: 28))
                    .foregroundStyle(Color.lootBeige)
                    .padding([.leading, .trailing, .top], 20)
                Divider()
                    .frame(height: 1)
                    .background(Color.black)
                VStack {
                    if layout.card.type == .guessing || layout.card.type == .targeted {
                        HStack {
                            Picker("Choose a Player", selection: $fieldValuePlayer) {
                                ForEach(players, id: \.id) {
                                    Text($0.player.name).tag($0.player.name)
                                }
                            }
                        }
                        if layout.card.type == .guessing {
                            HStack {
                                Picker("Card", selection: $fieldValueCard) {
                                    ForEach(layout.cardNames, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                        }
                    }
                }
                    .font(.custom("Quasimodo", size: 18))
                    .foregroundStyle(Color.lootBeige)
                    .multilineTextAlignment(.center)
                    .padding()
                HStack {
                    CustomButton(text: "Cancel", onClick: {toggle.toggle()}, buttonColor: Color.red)
                    CustomButton(text: "Play", onClick: {
                        // switch on the type of card that was played
                        switch layout.card.type {
                        case .normal:
                            game.playNormalCard(gamePlayer: player, card: layout.card)
                        case .guessing:
                            guard let guessedOn = players.first(where: {$0.player.name == fieldValuePlayer}) else {
                                print("player not found when playing guessing card")
                                return
                            }
                            guard let index = layout.cardNames.firstIndex(where: {$0 == fieldValueCard}) else {
                                print("card not found from name")
                                return
                            }
                            game.playGuessingCard(gamePlayer: player, guessedOn: guessedOn, card: layout.card, guessedCard: index + 1)
                        case .targeted:
                            guard let targeted = players.first(where: {$0.player.name == fieldValuePlayer}) else {
                                print("player not found when playing targeted card")
                                return
                            }
                            game.playTargetCard(gamePlayer: player, targetPlayer: targeted, card: layout.card)
                        case .none:
                            break
                        }
                        game.animationHandler.playCard(player: player, card: layout.card)
                        player.isCurrentTurn = false
                    })
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
