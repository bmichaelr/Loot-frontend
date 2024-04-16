//
//  ShowCardView.swift
//  CardTest
//
//  Created by Joshua Singontiko on 4/16/24.
//

import SwiftUI

struct WinnerView: View {
    @Binding var isShowing: Bool
    @State private var offset: CGFloat = 1000
    @State private var opacity: CGFloat = 0.0
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
                CustomButton(text: "Dismiss") {
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
        VStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color.lootBeige)
                VStack(alignment: .center) {
                    Text("Ben Won the game!")
                        .font(.custom("Quasimodo", size: 18))
                    Image("loot_3")
                        .frame(width: 20)
                    Spacer()
                    Text(card.description)
                        .font(.custom("Quasimodo", size: 16))
                        .multilineTextAlignment(.leading)
                }
                .padding(.top, 30)
            }
        }
        .foregroundStyle(Color.black)
        .frame(width: 250, height: 400)
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(lineWidth: 7)
            .foregroundStyle(.yellow)
            .shadow(color: .yellow, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        )
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
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
    func winnerView(isPresented: Binding<Bool>, card: Card, onTap: @escaping () -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                WinnerView(isShowing: isPresented, card: card, onTap: onTap)
            }
        }
    }
}

#Preview {
    WinnerView(isShowing: .constant(true), card: Card(number: 5), onTap: {
        print("syced")
    })
}
