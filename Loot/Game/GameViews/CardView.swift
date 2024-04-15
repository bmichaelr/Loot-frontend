//
//  CardView.swift
//  Loot
//
//  Created by Joshua on 3/30/24.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var card: Card
    @Namespace var animation
    let namespace: Namespace.ID
    let size: CardSize
    var body: some View {
        let width: CGFloat = size == .small ? 60 : 80
        let height: CGFloat = size == .small ? 90 : 110
        let color = card.faceDown ? Color.lootBrown : Color.lootBeige
        let strokeSize: CGFloat = card.faceDown ? 1 : 3
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(color)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: strokeSize)
                    .foregroundStyle(Color.lootBrown)
                )
            buildCard()
        }
        .frame(width: width, height: height)
        .matchedGeometryEffect(id: card.id, in: namespace, properties: .frame, anchor: .center)
        .transition(.scale(scale: 1))
        .rotation3DEffect(.degrees(card.faceDown ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
    @ViewBuilder
    private func buildCard() -> some View {
        if card.faceDown {
            Image("dragon")
                .resizable()
                .scaledToFit()
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
        } else {
            VStack(alignment: .leading) {
                Text(String(card.number))
                    .font(.custom("Quasimodo", size: 16))
                    .padding([.leading, .top], 8)
                Image("loot_\(card.number)")
                    .resizable()
                    .scaledToFit()
                    .offset(y: -10)
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    struct Wrapper: View {
        @Namespace var animation
        var card: Card {
            let card = Card(number: 1)
            card.faceDown = false
            return card
        }
        var body: some View {
            CardView(card: card, namespace: animation, size: .small)
                .padding()
                .background(Color.gray)
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
