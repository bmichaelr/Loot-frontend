//
//  Leaderboard.swift
//  Loot
//
//  Created by Benjamin Michael on 4/22/24.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject var model: LeaderboardViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack {
                    Text("Leaderboard")
                        .font(.custom("Quasimodo", size: 36))
                        .padding()
                    List {
                        ForEach(model.leaderboard.entries.indices, id: \.self) { index in
                            let entry = model.leaderboard.entries[index]
                            LeaderboardEntryView(entry: entry, ranking: index)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .frame(maxHeight: 500)
                    .listStyle(.plain)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.lootBrown)
                            .shadow(radius: 20)
                    }
                    .padding(.horizontal, 25)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackground()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("dragon")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

#Preview {
    LeaderboardView(model: LeaderboardViewModel(id: UUID(), name: "Ben", stomp: StompClient()))
}
