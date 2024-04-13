//
//  PlayCardView.swift
//  Loot
//
//  Created by Michael, Ben on 4/9/24.
//

import SwiftUI

struct PlayCardView: View {
    @Binding var isShowing: Bool
    @Binding var isMyTurn: Bool
    @State private var offset: CGFloat = 1000
    @State private var opacity: CGFloat = 0.0
    @State private var playing: Bool = false
    @State private var pickedPlayer: String = ""
    @State private var pickedCard: String = ""
    @Namespace var animation
    var gameState: GameState
    var cardToShow: Card
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all).opacity(opacity)
                .zIndex(1.0)
                .onTapGesture {
                    close()
                }
            VStack(alignment: .center) {
                if !playing {
                    buildCardView()
                        .matchedGeometryEffect(id: "card", in: animation)
                    if isMyTurn {
                        CustomButton(text: "Play Card", onClick: {
                            withAnimation {
                                playing.toggle()
                            }
                        })
                        .matchedGeometryEffect(id: "playBtn", in: animation)
                        .padding()
                    }
                } else {
                    buildPlayingView()
                        .matchedGeometryEffect(id: "card", in: animation)
                }
            }
            .foregroundStyle(Color.black)
            .zIndex(2.0)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
            .offset(y: offset)
        }
        .onAppear {
            withAnimation {
                opacity = 0.15
            }
        }
    }
    private func close() {
        withAnimation {
            opacity = 0
            offset = 1000
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isShowing = false
        }
    }
    @ViewBuilder
    private func buildCardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.lootBeige)
            VStack(alignment: .leading) {
                Text(String(cardToShow.number))
                    .font(.custom("Quasimodo", size: 48))
                    .padding(.leading, 15)
                    .padding(.top, 5)
                Image("loot_\(cardToShow.number)")
                    .resizable()
                    .scaledToFit()
                Spacer()
                Text(cardToShow.description)
                    .font(.custom("Quasimodo", size: 16))
                    .multilineTextAlignment(.leading)
            }
            .padding()
        }
        .frame(width: 250, height: 400)
        .overlay(RoundedRectangle(cornerRadius: 30).stroke(lineWidth: 7))
    }
    @ViewBuilder
    private func buildPlayingView() -> some View {
        let width = UIScreen.main.bounds.width - 40
        let height = getHeight()
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.lootBrown)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke())
            VStack(alignment: .leading) {
                Text("Playing: \(cardToShow.name)")
                    .font(.custom("Quasimodo", size: 18))
                    .foregroundStyle(Color.lootBeige)
                    .padding(.leading, 20)
                Spacer()
                buildCardSpecificData()
                Spacer()
                HStack {
                    CustomButton(text: "Cancel", onClick: {
                        withAnimation {
                            playing = false
                        } completion: {
                            close()
                        }
                    }, buttonColor: Color.red)
                    Spacer()
                    CustomButton(text: "Play", onClick: {
                        if cardNotAbleToBePlayed() { return }
                        withAnimation {
                            playing = false
                        } completion: {
                            close()
                            gameState.playCard(player: pickedPlayer, card: pickedCard, play: cardToShow)
                        }
                    })
                    .matchedGeometryEffect(id: "playBtn", in: animation)
                }
                .padding()
            }
            .padding()
        }
        .frame(width: width, height: height)
    }
    @ViewBuilder
    private func buildCardSpecificData() -> some View {
        switch cardToShow.number {
        case 1:
            VStack {
                HStack {
                    Text("Choose player to play on: ")
                        .font(.custom("Quasimodo", size: 18))
                        .foregroundStyle(Color.lootBeige)
                    Spacer()
                    Picker("Select player:", selection: $pickedPlayer) {
                        Text("").tag("")
                        ForEach(gameState.getPlayerOptions(for: cardToShow.number), id: \.self) { player in
                            Text(player)
                        }
                    }
                }
                HStack {
                    Text("Pick card to guess:")
                        .font(.custom("Quasimodo", size: 18))
                        .foregroundStyle(Color.lootBeige)
                    Spacer()
                    Picker("Select card:", selection: $pickedCard) {
                        Text("").tag("")
                        ForEach(gameState.getCardOptions(for: cardToShow.number), id: \.self) { card in
                            Text(card).tag(card)
                        }
                    }
                }
            }
        case 2, 3, 5, 6:
            HStack {
                Text("Choose player to play on: ")
                    .font(.custom("Quasimodo", size: 18))
                    .foregroundStyle(Color.lootBeige)
                Spacer()
                Picker("Select player:", selection: $pickedPlayer) {
                    Text("").tag("")
                    ForEach(gameState.getPlayerOptions(for: cardToShow.number), id: \.self) { player in
                        Text(player)
                    }
                }
            }
        default:
            EmptyView()
        }
    }
    private func getHeight() -> CGFloat {
        switch cardToShow.number {
        case 1:
            return CGFloat(integerLiteral: 200)
        case 2, 3, 5, 6:
            return CGFloat(integerLiteral: 150)
        default:
            return CGFloat(integerLiteral: 100)
        }
    }
    private func cardNotAbleToBePlayed() -> Bool {
        switch cardToShow.number {
        case 1:
            return pickedPlayer.isEmpty || pickedCard.isEmpty
        case 2, 3, 5, 6:
            return pickedPlayer.isEmpty
        default:
            return false
        }
    }
}

extension View {
    func showPlayCard(isPresented: Binding<Bool>, show card: Card, game: GameState, myTurn: Binding<Bool>) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                PlayCardView(isShowing: isPresented, isMyTurn: myTurn, gameState: game, cardToShow: card)
            }
        }
    }
}

// #Preview {
//    PlayCardView(isShowing: .constant(true), isMyTurn: .constant(true), cardToShow: Card(number: 5))
//        .environmentObject(GameState(players: [Player](), myId: UUID(), roomKey: "beans", stompClient: StompClient()))
// }
