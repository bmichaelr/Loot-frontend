//
//  HandView.swift
//  Loot
//
//  Created by Joshua on 3/30/24.
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
            Image(systemName: "xmark")
                .foregroundStyle(Color.red)
        } else if player.isSafe {
            Image(systemName: "shield.fill")
                .foregroundStyle(Color.blue)
        }
        EmptyView()
    }
    @ViewBuilder
    private func getCardView() -> some View {
        switch cardSize {
        case .small:
            VStack {
                Text(player.name)
                    .overlay(getPlayerStatus().offset(x: -50))
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
            }
            .frame(width: 120, height: 110)
            .fixedSize(horizontal: true, vertical: true)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke())
        case .large:
            VStack {
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
                .overlay(RoundedRectangle(cornerRadius: 10).stroke())
            }
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
}

//struct HandView_Previews: PreviewProvider {
//    struct Wrapper: View {
//        @Namespace var namespace
//        
//        var hand: Hand {
//            let hand = Hand()
//            hand.cards.append(contentsOf: [
//                Card(number: 1),
//                Card(number: 2),
//            ])
//            return hand
//        }
//        
//        var body: some View {
//            // TODO: make some sample data to test
//            //HandView(hand: hand, player: Player(from: player1), namespace: namespace, onCardTap: { _ in }, cardSize: .small)
//        }
//    }
//    
//    static var previews: some View {
//        Wrapper()
//    }
//}
