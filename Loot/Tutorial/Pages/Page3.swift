//
//  Page3.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI
import BigUIPaging

struct Page3: View {
    var cards: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    @State private var selectedIndex: Int = 0
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Cards")
                    .font(.custom("Quasimodo", size: 28))
                    .foregroundStyle(Color.black)
                    .padding(.leading)
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                VStack {
                    HStack {
                        Spacer()
                        PageView(selection: $selectedIndex) {
                            ForEach(cards.indices, id: \.self) { index in
                                makeCardView(for: cards[index]).tag(index)
                            }
                        }
                        .pageViewStyle(.cardDeck)
                        Spacer()
                    }
                }
                CardDescriptionView(cardNumber: selectedIndex + 1)
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
    }
    @ViewBuilder
    private func makeCardView(for power: Int) -> some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 35)
                    .foregroundStyle(Color.lootBeige)
                VStack(alignment: .leading) {
                    Text(String(power))
                        .font(.custom("Quasimodo", size: 48))
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    Image("loot_\(power)")
                        .resizable()
                        .scaledToFit()
                        .offset(y: -20)
                }
                .padding()
            }
        }
        .foregroundStyle(Color.black)
        .frame(width: 200, height: 300)
        .overlay(RoundedRectangle(cornerRadius: 45).stroke(lineWidth: 15).foregroundStyle(Color.lootBrown)
        )
    }
    @ViewBuilder
    private func generateTextAboutCard() -> some View {
        switch selectedIndex {
        case 0:
            VStack(alignment: .center) {
                HStack {
                    Text("Card Name: ")
                        .font(.custom("windlass", size: 18))
                    Text("Potted Plant")
                }
                Text("Pick any player that is in the round and not out or safe, and guess what card they have in their hand. If you guess right, nothing happens.")
            }
        default:
            VStack {
                Text("Some other card")
            }
        }
    }
}

#Preview {
    Page3()
}
