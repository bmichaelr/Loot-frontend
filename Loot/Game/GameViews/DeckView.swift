//
//  DeckView.swift
//  Loot
//
//  Created by Michael, Ben on 4/9/24.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject var deck: Hand
    let namespace: Namespace.ID
    var body: some View {
        ZStack {
            ForEach(deck.cards.suffix(2)) {
                CardView(card: $0, namespace: namespace, size: .small)
            }
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    struct Wrapper: View {
        @Namespace var namespace
        var deck: Hand {
            let deck = Hand()
            deck.cards.append(contentsOf: [
                Card(number: 1),
                Card(number: 2)
            ])
            return deck
        }
        var body: some View {
            DeckView(deck: deck, namespace: namespace)
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
