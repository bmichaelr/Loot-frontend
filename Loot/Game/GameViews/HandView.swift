//
//  HandView.swift
//  Loot
//
//  Created by Joshua on 3/30/24.
//  Edited by Ben 😈 on 4/14/24
//

import SwiftUI

struct HandView: View {
    @ObservedObject var hand: Hand
    @ObservedObject var player: GamePlayer
    var isMe: Bool = false
    let namespace: Namespace.ID
    let onCardTap: ((Card) -> Void)?
    let cardSize: CardSize
    var body: some View {
        if !isMe {
            getCardView()
        } else {
            getMyCardView()
        }
    }
    @ViewBuilder
    private func getPlayerStatus() -> some View {
        if player.isOut {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.red.opacity(0.40))
                Image(systemName: "xmark")
                    .font(.system(size: 75))
                    .foregroundStyle(.red)
            }
        } else if player.isSafe {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.40))
                Image(systemName: "shield.fill")
                    .foregroundStyle(Color.white.opacity(0.80))
                    .font(.system(size: 75))
                Image(systemName: "shield.fill")
                    .foregroundStyle(Color.blue)
                    .font(.system(size: 70))
            }
        }
        EmptyView()
    }
    @ViewBuilder
    private func getCardView() -> some View {
        switch cardSize {
        case .small:
            HStack(spacing: -25) {
                ForEach(hand.cards) { card in
                    CardView(card: card, namespace: namespace, size: cardSize)
                        .onTapGesture {
                            if let onTap = onCardTap {
                                onTap(card)
                            }
                        }
                }
            }
            .shadow(color: .yellow, radius: player.currentTurn ? 10 : 0)
            .frame(width: 120, height: 110)
            .fixedSize(horizontal: true, vertical: true)
            .padding(5)
            .padding(.top, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .foregroundStyle(.white)
            )
            .overlay(alignment: .topLeading) {
                Text(formatPlayerName(name: player.name))
                    .font(.custom("CaslonAntique", size: 22))
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
                    .padding(.top, 4)
            }
            .overlay(alignment: .topTrailing) {
                ZStack {
                    if player.hasCoin {
                        Image("lootCoin")
                            .matchedGeometryEffect(id: "coin", in: namespace)
                            .offset(CGSize(width: 0, height: 5))
                    }
                    Image("lootCoinBackground_large")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding([.top, .trailing], 3)
                        .foregroundStyle(.yellow)
                        .font(.title)
                        .overlay(alignment: .center) {
                            Text(String(player.numberOfWins))
                                .font(.custom("CaslonAntique", size: 20))
                                .foregroundStyle(.black.opacity(0.8))
                                .padding([.trailing], 3)
                        }.confettiCannon(counter: $player.counter, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                }
            }
            .overlay {
                getPlayerStatus()
            }
        case .large:
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -40) {
                    ForEach(hand.cards) { card in
                        CardView(card: card, namespace: namespace, size: cardSize)
                            .onTapGesture {
                                if let onTap = onCardTap {
                                    onTap(card)
                                }
                            }
                    }
                }
                .padding(5)
            }
            .frame(height: 110)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke().foregroundStyle(.white))
        }
    }
    @ViewBuilder
    func getMyCardView() -> some View {
        switch cardSize {
        case .small:
            let width = UIScreen.main.bounds.width - 20
            HStack(spacing: -25) {
                ForEach(hand.cards) { card in
                    CardView(card: card, namespace: namespace, size: .small)
                        .onTapGesture {
                            if let onTap = onCardTap {
                                onTap(card)
                            }
                        }
                }
            }
            .fixedSize(horizontal: true, vertical: true)
            .frame(width: width, height: 110)
        case .large:
            let size = hand.cards.count
            let offset: Double = size > 1 ? 10 : 0
            HStack(spacing: -30) {
                ForEach(Array(hand.cards.enumerated()), id: \.1.id) { (index, card) in
                    CardView(card: card, namespace: namespace, size: .large)
                        .rotationEffect(Angle(degrees: index == 1 ? offset : -offset))
                        .onTapGesture {
                            if let onTap = onCardTap {
                                onTap(card)
                            }
                        }
                }
            }
        }
    }
    private func formatPlayerName(name: String) -> String {
        if name.count < 9 {
            return name
        }
        return name.prefix(9) + ".."
    }
}

 struct HandView_Previews: PreviewProvider {
    struct Wrapper: View {
        @Namespace var namespace
        var hand: Hand {
            let hand = Hand()
            hand.cards.append(contentsOf: [
                Card(number: 1),
                Card(number: 2)
            ])
            return hand
        }
        var body: some View {
            HandView(hand: hand, player: GamePlayer(from: mainPlayer),
              namespace: namespace, onCardTap: { _ in }, cardSize: .small)
        }
    }
    static var previews: some View {
        ZStack {
            Image("CardTableTexture")
            Wrapper()
        }
    }
 }
