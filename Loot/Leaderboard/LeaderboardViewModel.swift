//
//  LeaderboardViewModel.swift
//  Loot
//
//  Created by Benjamin Michael on 4/22/24.
//

import Foundation

@Observable
class LeaderboardViewModel: ObservableObject {
    var stompClient: StompClient
    var player: Player
    var leaderboard = LeaderboardResponse.test()
    init(id: UUID, name: String, stomp: StompClient) {
        player = Player(name: name, id: id)
        stompClient = stomp
    }
}
