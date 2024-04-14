//
//  RoundLogList.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import SwiftUI

struct RoundLogList: View {
    @ObservedObject var round: RoundLog
    @State private var showing = true
    var body: some View {
        Section {
            if showing {
                ForEach(round.messages) { msg in
                    MessageRow(message: msg)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 1, opacity: 0.9))
                        .padding(.vertical, 2).padding(.horizontal, 20)
                )
                .listRowSeparator(.hidden)
            }
        } header: {
            HStack {
                Text("Round \(round.roundNumber):")
                    .foregroundStyle(Color.lootBeige)
                    .font(.custom("CaslonAntique", size: 22))
                Spacer()
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Color.lootBeige)
                    .rotationEffect(showing ? Angle(degrees: 90) : .zero)
                    .onTapGesture {
                        withAnimation(.spring) {
                            showing.toggle()
                        }
                    }
            }
            .padding(.horizontal)
        } footer: {
            Text(round.winningMessage)
                .foregroundStyle(Color.lootBeige)
                .font(.custom("CaslonAntique", size: 22))
        }
        .listSectionSeparator(.visible)
    }
}

#Preview {
    RoundLogList(round: RoundLog(roundNumber: 1))
}
