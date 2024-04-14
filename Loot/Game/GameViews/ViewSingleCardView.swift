//
//  ShowCardView.swift
//  CardTest
//
//  Created by Benjamin Michael on 4/7/24.
//

import SwiftUI

struct ViewSingleCardView: View {
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
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color.lootBeige)
                VStack(alignment: .leading) {
                    Text(String(card.number))
                        .font(.custom("Quasimodo", size: 48))
                        .padding(.leading, 15)
                        .padding(.top, 5)
                    Image("loot_\(card.number)")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    Text(card.description)
                        .font(.custom("Quasimodo", size: 16))
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
        }
        .foregroundStyle(Color.black)
        .frame(width: 250, height: 400)
        .overlay(RoundedRectangle(cornerRadius: 35)
            .stroke(lineWidth: 7)
            .foregroundStyle(Color.lootBrown)
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
    func viewSingleCard(isPresented: Binding<Bool>, card: Card, onTap: @escaping () -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                ViewSingleCardView(isShowing: isPresented, card: card, onTap: onTap)
            }
        }
    }
}

#Preview {
    ViewSingleCardView(isShowing: .constant(true), card: Card(number: 5), onTap: {
        print("syced")
    })
}
