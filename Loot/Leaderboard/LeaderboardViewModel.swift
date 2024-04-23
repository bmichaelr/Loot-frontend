//
//  LeaderboardViewModel.swift
//  Loot
//
//  Created by Benjamin Michael on 4/22/24.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    var stompClient: StompClient
    var player: Player
    @Published var leaderboard = LeaderboardResponse()
    init(id: UUID, name: String, stomp: StompClient) {
        player = Player(name: name, id: id)
        stompClient = stomp
    }
    func setup() {
        let idStr = player.id.uuidString
        stompClient.registerListener("/topic/leaderboard/" + idStr, using: handleLeaderboardUpdates)
        stompClient.registerListener("/topic/leaderboard", using: handleLeaderboardUpdates)
        stompClient.sendData(body: player, to: "/app/leaderboard/fetchStandings")
    }
    func handleLeaderboardUpdates(_ data: Data) {
        do {
            let parsed = try JSONDecoder().decode([LeaderboardEntry].self, from: data)
            leaderboard.entries = parsed
        } catch {
            print("Error decoding leaderboard response!")
        }
    }
}
