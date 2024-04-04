//
//  HandView.swift
//  Loot
//
//  Created by Joshua on 3/30/24.
//

import SwiftUI

struct HandView: View {
    @ObservedObject var hand: Hand
    let namespace: Namespace.ID
    let onCardTap: (Card) -> Void
    var body: some View {
        HStack(spacing: -40) {
            ForEach(hand.cards) { card in
                CardView(card: card, namespace: namespace)
                    .onTapGesture {
                        onCardTap(card)
                    }
            }
        }
    }
}

struct DeckView: View {
    @ObservedObject var hand: Hand
    let namespace: Namespace.ID
    let onCardTap: (Card) -> Void
    var body: some View {
        ZStack {
            ForEach(hand.cards) { card in
                CardView(card: card, namespace: namespace)
                    .offset(x: hand.shuffled ? CGFloat.random(in: -100...100) : 0, y: hand.shuffled ? CGFloat.random(in: -100...100) : 0)                    .onTapGesture {
                        onCardTap(card)
                    }
                    .rotationEffect(Angle(degrees: Double.random(in: 0..<3)))

            }
        }
    }
}
