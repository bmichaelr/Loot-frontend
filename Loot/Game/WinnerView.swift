//
//  ShowCardView.swift
//  CardTest
//
//  Created by Joshua Singontiko on 4/16/24.
//

import SwiftUI
import ConfettiSwiftUI

struct WinnerView: View {
    @Binding var isShowing: Bool
    @State private var offset: CGFloat = 1000
    @State private var opacity: CGFloat = 0.0
    @State private var confetti: Int = 0
    @Namespace private var namespace
    var winner: GamePlayer
    var card: Card
    var onTap: () -> Void
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all).opacity(opacity)
                .zIndex(1.0)
            VStack(spacing: 20) {
                HStack {
                    buildCompareCardView(card: card)
                }
                .onTapGesture {
                    close()
                }
                CustomButton(text: "Home") {
                    onTap()
                    close()
                }
                .frame(width: 250)
                .offset(y: offset)
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
    private func buildCompareCardView(card: Card) -> some View {
        VStack {
            ZStack {
                Image("CardTableBackground")
                    .resizable()
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 45))
                    .overlay(RoundedRectangle(cornerRadius: 45)
                        .stroke(lineWidth: 7)
                        .foregroundStyle(.orange)
                    )
                Image("crown").offset(CGSize(width: 0.0, height: -300))
                VStack {
                    Text("\(winner.name) Won")
                        .foregroundStyle(Color.lootBeige)
                        .font(.custom("Quasimodo", size: 36))
                    buildCustomCardView(card: card)
                        .confettiCannon(counter: $confetti, num: 50)
                }
            }
        }
        .foregroundStyle(Color.black)
        .frame(width: 300)
        .onAppear {
            withAnimation(.spring()) {
                offset = 100
            } completion: {
                self.confetti += 1
            }
        }
        .offset(y: offset)
    }
    @ViewBuilder
    private func buildCustomCardView(card: Card) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundStyle(Color.lootBeige)
            VStack(alignment: .leading) {
                Text(String(card.number))
                    .font(.custom("Quasimodo", size: 24))
                    .padding(.leading, 12)
                    .padding(.top, 16)
                Image("loot_\(card.number)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 175, height: 230)
        .overlay(RoundedRectangle(cornerRadius: 25.0)
            .stroke(lineWidth: 8))
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
    func winnerView(isPresented: Binding<Bool>, card: Card, winner: GamePlayer, onTap: @escaping () -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                WinnerView(isShowing: isPresented, winner: winner, card: card, onTap: onTap)
            }
        }
    }
}

#Preview {
    WinnerView(isShowing: .constant(true), winner: GamePlayer(from: Player(name: "Josh", id: UUID())), card: Card(number: 5), onTap: {
        print("syced")
    })
}
