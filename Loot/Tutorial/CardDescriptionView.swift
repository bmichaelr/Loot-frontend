//
//  CardDescriptionView.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct CardDescriptionView: View {
    let cardNumber: Int
    let width = UIScreen.main.bounds.width
    var body: some View {
        VStack {
            HStack {
                Text("Card Name:")
                Spacer()
                Text(getCardName())
            }
            Divider()
            HStack {
                Text("Number per deck: ")
                Spacer()
                Text(getNumberInDeck())
            }
            Divider()
            Text("Description:")
                .fontWeight(.bold)
            Text(getCardDescription())
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
        .font(.custom("CaslonAntique", size: 24))
        .foregroundStyle(.black)
        .frame(height: 350)
    }
    private func getNumberInDeck() -> String {
        switch cardNumber {
        case 2, 3, 4, 5: "2"
        case 1: "5"
        default: "1"
        }
    }
    private func getCardName() -> String {
        switch cardNumber {
        case 1: "Potted Plant"
        case 2: "Maul Rat"
        case 3: "Duck of Doom"
        case 4: "Wishing Ring"
        case 5: "Net Troll"
        case 6: "Dread Gazebo"
        case 7: "Turbonium Dragon"
        case 8: "Loot"
        default: "Unknown card"
        }
    }
    private func getCardDescription() -> String {
        switch cardNumber {
        case 1:
            "Choose any player that is in the round and is not safe. Guess the card that "
            + "they have - you can guess any card except the Potted Plant. "
            + "Remember, there are only so many of each card in the game, so use the "
            + "information to your advantage."

        case 2:
            "Choose another player in the round that is not safe, you may look at "
            + "their hand. This reveals that players card to you."
        case 3:
            "Pick another player, and compare hands. You compare the card in your "
            + "hand versus theirs: the person with the lower value card is out of "
            + "the round. If a tie, nothing happens."
        case 4:
            "When playing this card, you are safe until your next turn comes to "
            + "pass. This means you are safe from any and all effects of other "
            + "players cards."
        case 5:
            "Pick another player (or yourself) to discard their hand. That person "
            + "then draws another card if there are any left, and they are not out."
        case 6:
            "Choose another player other than yourself, and swap hands with them. "
            + "They will have your card, and you will have theirs."
        case 7:
            "You must discard this card if you have the net troll or the dread gazebo "
            + "in your hand at the same time."
        case 8:
            "The best card in the game, yet the riskiest. If for any reason you discard "
            + "this card, you are out of the round."
        default: "Unknown card"
        }
    }
}

#Preview {
    CardDescriptionView(cardNumber: 1)
}
