//
//  CardView.swift
//  Loot
//
//  Created by Joshua on 3/30/24.
//

import SwiftUI

struct CardView: View {
    var number: Int
    let namespace: Namespace.ID
    let id: UUID
    let width: CGFloat = 70
    let scale: CGFloat = 2.0 / 3.0
    @ObservedObject var card: Card
    @State var flipped: Bool = false
    init(card: Card, namespace: Namespace.ID) {
        self.card = card
        self.number = card.power
        self.namespace = namespace
        self.id = card.id
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.faceDown ? Color.lootBrown : Color.lootBeige)
                .frame(width: width, height: width * scale + width)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.lootBrown, lineWidth: 8))
            Image(card.faceDown ? "dragon" : "loot_\(number)")
                .resizable()
                .scaledToFit()
                .frame(width: width, height: width * scale + width)
            Text(card.faceDown ? "Loot!" : "\(number)")
                .font(.custom("Quasimodo", size: card.faceDown ? 13 * scale + 13 : 15 * scale + 15))
                .foregroundColor(card.faceDown ? Color.lootBeige : .black)
                .frame(alignment: .leading)
                .padding(card.faceDown ? 6 * scale + 6 : 7 * scale + 7)
                .rotation3DEffect(card.faceDown ? Angle(degrees: 180) : Angle(degrees: 0), axis: (x: 0, y: 1, z: 0))
        }
        .matchedGeometryEffect(id: "\(id)", in: namespace, isSource: true)
        .rotation3DEffect(card.faceDown ? Angle(degrees: 180) : Angle(degrees: 0), axis: (x: 0, y: 1, z: 0), anchor: .center)
    }

}
