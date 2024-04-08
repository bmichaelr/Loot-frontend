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
                    .onTapGesture {
                        onCardTap(card)
                    }

            }
        }
    }
}
