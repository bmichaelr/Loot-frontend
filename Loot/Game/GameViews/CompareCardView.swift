//
//  CompareCardView.swift
//  Loot
//
//  Created by Man, J on 4/9/24.
//

import SwiftUI

struct CompareCardView: View {
    @Binding var isShowing: Bool
    @State private var offset: CGFloat = 1000
    @State private var opacity: CGFloat = 0.0
    var cards = [Card]()
    var nameCards: [CardNameStruct] = [CardNameStruct]()
    var onTap: () -> Void
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all).opacity(opacity)
                .zIndex(1.0)
            VStack(spacing: 20) {
                HStack {
                    ForEach(nameCards) {
                        buildCompareCardView(cardName: $0)
                    }
                }
                .onTapGesture {
                    close()
                }
                CustomButton(text: "Dismiss") {
                    onTap()
                    close()
                }
                .offset(y: offset)
                .frame(width: 300)
            }
            .zIndex(2.0)
        }
        .onAppear {
            withAnimation {
                opacity = 0.5
            }
        }
    }
    @ViewBuilder
    private func buildCompareCardView(cardName: CardNameStruct) -> some View {
        VStack(spacing: 20) {
            Text("\(cardName.name)'s card")
                .multilineTextAlignment(.center)
                .font(.custom("Quasimodo", size: 16))
            VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(Color.lootBeige)
                    VStack(alignment: .leading) {
                        Text(String(cardName.card.number))
                            .font(.custom("Quasimodo", size: 24))
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        Image("loot_\(cardName.card.number)")
                            .resizable()
                            .scaledToFit()
                            .offset(y: -20)
                    }
                    .padding()
                }
            }
            .foregroundStyle(Color.black)
            .frame(width: 150, height: 240)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(lineWidth: 7))
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .offset(y: offset)
    }
    private func close() {
        withAnimation {
            opacity = 0
            offset = 1000
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isShowing = false
        }
    }
}

extension View {
    func compareCards(isPresented: Binding<Bool>, cardNames: [CardNameStruct], onTap: @escaping () -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                CompareCardView(isShowing: isPresented, nameCards: cardNames, onTap: onTap)
            }
        }
    }
}

#Preview {
    CompareCardView(
        isShowing: .constant(true),
        nameCards: [CardNameStruct(card: Card(number: 5), name: "Bartholemew"),
                    CardNameStruct(card: Card(number: 3), name: "Ben")],
        onTap: {
        print("syced")
    })
}
