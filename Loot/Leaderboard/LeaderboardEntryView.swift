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
                .foregroundStyle(Color.lootBeige)
                .shadow(radius: 10)
        }
    }
}

#Preview {
    LeaderboardEntryView(entry: LeaderboardEntry(playerName: "Ben", numberOfWins: 10), ranking: 1)
}
