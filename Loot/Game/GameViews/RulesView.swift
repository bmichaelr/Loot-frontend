//
//  RulesView.swift
//  Loot
//
//  Created by Benjamin Michael on 4/12/24.
//

import SwiftUI

let lastRule = "4. When the last card is drawn and discarded, or when there " +
                "is only one player left in the round, the round ends. The " +
                "remaining player with the highest value card in hand wins " +
                "that round and gains a loot token!"

struct RuleOverlay: View {
    @State private var showRules = false
    @Namespace var namespace
    let backgroundID = UUID()
    let textId = UUID()
    let imageId = UUID()
    var body: some View {
        VStack {
            if showRules {
                RuleView(isPresented: $showRules, namespace: namespace, bId: backgroundID, iId: imageId, tId: textId)
            } else {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .matchedGeometryEffect(id: textId, in: namespace)
                            .frame(width: 75, height: 75)
                            .foregroundStyle(Color.lootBrown)
                        RoundedRectangle(cornerRadius: 20)
                            .matchedGeometryEffect(id: backgroundID, in: namespace)
                            .frame(width: 75, height: 75)
                            .foregroundStyle(Color.lootBrown)
                            .overlay {
                                Image(systemName: "text.book.closed.fill")
                                    .matchedGeometryEffect(id: imageId, in: namespace)
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.lootBeige)
                            }
                            .onTapGesture {
                                withAnimation {
                                    showRules.toggle()
                                }
                            }
                            .shadow(radius: 5)
                    }
                    .offset(x: 10)
                }
            }
        }
    }
}

struct RuleView: View {
    @Binding var isPresented: Bool
    @State private var flipped = false
    var namespace: Namespace.ID
    var bId: UUID
    var iId: UUID
    var tId: UUID
    let width = UIScreen.main.bounds.width - 50
    let height = (UIScreen.main.bounds.width - 50) * 1.66
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .matchedGeometryEffect(id: iId, in: namespace)
                .frame(width: width, height: height)
                .foregroundStyle(Color.lootBeige)
                .overlay {
                    RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 11).foregroundStyle(Color.lootBrown)
                        .matchedGeometryEffect(id: bId, in: namespace)
                }
            if isPresented {
                getBody()
                    .matchedGeometryEffect(id: tId, in: namespace)
                    .padding([.leading, .trailing])
                    .frame(width: width - 20, height: height - 20)
            }
        }
        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation {
                flipped.toggle()
            }
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.height > 50 {
                        withAnimation(.linear) {
                            self.isPresented = false
                        }
                    }
                }
        )
    }
    @ViewBuilder
    private func getBody() -> some View {
        if flipped {
            VStack(alignment: .leading, spacing: 10) {
                Text("List of cards")
                    .font(.custom("Windlass", size: 36))
                    .padding([.top])
                VStack(alignment: .leading) {
                    Text("8 - Loot(1): Lose if discarded.")
                    Text("7 - Turbonium Dragon(1): Discard if with Dread Gazebo or Net Troll.")
                    Text("6 - Dread Gazebo(1): Trade hands with another player.")
                    Text("5 - Net Troll(2): One player discards their hand.")
                    Text("4 - Wishing Ring(2): Protection until your next turn.")
                    Text("3 - Duck of Doom(2): Compare hands; lower hand is out, tie nothing happens.")
                    Text("2 - Maul Rat(2): Look at a hand.")
                    Text("1 - Potted Plant(5): Guess a player's hand.")
                }
                .font(.custom("CaslonAntique", size: 28))
                Spacer()
                Text("Tap to see sequence of play")
                    .font(.custom("Windlass", size: 18))
            }
            .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
        } else {
            VStack(alignment: .leading, spacing: 10) {
                ScrollView(content: {
                    Text("Sequence of Play")
                        .font(.custom("Windlass", size: 36))
                        .padding([.top])
                    VStack(alignment: .leading, spacing: 10) {
                        Text("1. Shuffle the deck. Remove one card face down (do not flip any face up.)")
                        Text("2. Deal each player one card.")
                        Text("3. Each player, in turn, draws one card then discards one card. " +
                             "Apply any effects on the card discarded.")
                        Text(lastRule)
                    }
                    .font(.custom("CaslonAntique", size: 28))
                })
                Spacer()
                Text("Tap to see list of cards.")
                    .font(.custom("Windlass", size: 18))
            }
        }
    }
}

extension View {
    func showRules() -> some View {
        ZStack {
            self
            RuleOverlay()
        }
    }
}

struct RuleView_Previews: PreviewProvider {
    struct Wrapper: View {
        @Namespace var namespace
        let id = UUID()
        var body: some View {
            RuleOverlay()
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
