//
//  ShowCardView.swift
//  Loot
//
//  Created by Michael, Ben on 4/9/24.
//

import SwiftUI

struct ShowCardView: View {
    @Binding var isShowing: Bool
    @State private var offset: CGFloat = 1000
    @State private var opacity: CGFloat = 0.0
    var cardToShow: Card
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all).opacity(opacity)
                .zIndex(1.0)
            VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .foregroundStyle(Color.lootBeige)
                    VStack(alignment: .leading) {
                        Text(String(cardToShow.number))
                            .font(.custom("Quasimodo", size: 48))
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        Image("loot_\(cardToShow.number)")
                            .resizable()
                            .scaledToFit()
                            .offset(y: -20)
                        Spacer()
                        Text(cardToShow.description)
                            .font(.custom("Quasimodo", size: 16))
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .offset(y: -20)
                    }
                    .padding()
                }
            }
            .foregroundStyle(Color.black)
            .zIndex(2.0)
            .frame(width: 250, height: 400)
            .overlay(RoundedRectangle(cornerRadius: 35).stroke(lineWidth: 7))
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
            .offset(y: offset)
        }
        .onAppear {
            withAnimation {
                opacity = 0.15
            }
        }
        .onTapGesture {
            close()
        }
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
    func showCard(isPresented: Binding<Bool>, show card: Card) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                ShowCardView(isShowing: isPresented, cardToShow: card)
            }
        }
    }
}

struct ShowCardView_Previews: PreviewProvider {
    struct Wrapper: View {
        var card: Card {
            let card = Card(number: 5)
            card.description = "Chose another player to discard his/her hand."
            return card
        }
        var body: some View {
            ShowCardView(isShowing: .constant(true), cardToShow: card)
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
