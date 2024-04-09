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
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all).opacity(opacity)
                .zIndex(1.0)
            VStack {
                HStack {
                    ForEach(cards){
                        buildCompareCardView(card: $0)
                    }
                }
                .onTapGesture {
                    close()
                }
                buildCompareDismissButton()
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
                    .foregroundStyle(Color.green)
                VStack {
                    Text(String(card.number))
                    Spacer()
                    Image(systemName: "globe")
                        .font(.title)
                        .scaledToFill()
                    Text("Some wordy description here about how the card works")
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
        }
        .foregroundStyle(Color.black)
        .frame(width: 150, height: 240)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke())
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
            }
        }
        .offset(y: offset)
    }
    @ViewBuilder func buildCompareDismissButton() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.green)
            Text("Dismiss")
        }
        .frame(width: 200, height: 60, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke())
        .onAppear {
            withAnimation(.spring()) {
                offset = 0
            }
        }
        .onTapGesture {
            close()
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

#Preview {
    CompareCardView(isShowing: .constant(true), cards: [Card(number: 4),Card(number: 5)])
}
