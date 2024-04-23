//
//  LeaderboardEntryView.swift
//  Loot
//
//  Created by Benjamin Michael on 4/22/24.
//

import SwiftUI

struct LeaderboardEntryView: View {
    let entry: LeaderboardEntry
    let ranking: Int
    var body: some View {
        HStack {
            Image(systemName: "trophy.fill")
                .scaledToFit()
                .foregroundStyle(getTrophyColor(ranking))
            Text(String(ranking))
            Text(entry.playerName)
                .padding(.leading)
            Spacer()
            Text(String(entry.numberOfWins))
        }
        .font(.custom("CaslonAntique", size: 22))
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.white)
        }
    }
    private func getTrophyColor(_ num: Int) -> Color {
        switch num {
        case 1: Color.yellow
        case 2: Color.gray
        case 3: Color.brown
        default: Color.black
        }
    }
}

#Preview {
    LeaderboardEntryView(entry: LeaderboardEntry(playerName: "Ben", numberOfWins: 10), ranking: 1)
}
