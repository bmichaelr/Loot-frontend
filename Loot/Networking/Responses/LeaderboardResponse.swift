//
//  LeaderboardEntry.swift
//  Loot
//
//  Created by Benjamin Michael on 4/22/24.
//

import Foundation

struct LeaderboardResponse: Codable {
    static func test() -> LeaderboardResponse {
        var leaderboard = LeaderboardResponse()
        leaderboard.entries = testLeaderboardEntries
        return leaderboard
    }
    var entries: [LeaderboardEntry] = [LeaderboardEntry]()
}
struct LeaderboardEntry: Codable {
    let playerName: String
    let numberOfWins: CLong
}
