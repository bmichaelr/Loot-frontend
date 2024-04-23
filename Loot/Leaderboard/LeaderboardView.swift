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
                    VStack {
                        HStack {
                            Text("Rank")
                                .padding(.leading, 30)
                            Text("Name")
                                .padding(.leading)
                            Spacer()
                            Text("Wins")
                                .padding(.trailing, 40)
                        }
                        .padding(.top)
                        .font(.custom("CaslonAntique", size: 24))
                        .foregroundStyle(Color.lootBeige)
                        Divider()
                            .frame(height: 5)
                            .overlay(Color.lootBeige)
                        List {
                            ForEach(model.leaderboard.entries.indices, id: \.self) { index in
                                let entry = model.leaderboard.entries[index]
                                LeaderboardEntryView(entry: entry, ranking: index + 1)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .listRowSpacing(0)
                        .frame(maxHeight: 500)
                        .listStyle(.plain)
                    }
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
            .onAppear {
                model.setup()
            }
        }
    }
}

#Preview {
    LeaderboardView(model: LeaderboardViewModel(id: UUID(), name: "Ben", stomp: StompClient()))
}
