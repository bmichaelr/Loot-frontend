//
//  PreviewData.swift
//  Loot
//
//  Created by Benjamin Michael on 4/12/24.
//

import Foundation

let mainPlayer: Player = Player(name: "O_o", id: UUID())
let testPlayers: [Player] = [
    Player(name: "Josh", id: UUID()),
    Player(name: "Ian", id: UUID()),
    Player(name: "Kenna", id: UUID()),
    mainPlayer
]
let testId: UUID = mainPlayer.id

extension GameState {
    static func testInit() -> GameState {
        let stompClient = StompClient()
        let roomKey: String = "ABC123"
        return GameState(players: testPlayers, myId: testId, roomKey: roomKey, stompClient: stompClient)
    }
}

let testLeaderboardEntries: [LeaderboardEntry] = [
    LeaderboardEntry(playerName: "Ben", numberOfWins: 20),
    LeaderboardEntry(playerName: "Josh", numberOfWins: 11),
    LeaderboardEntry(playerName: "Ian", numberOfWins: 11),
    LeaderboardEntry(playerName: "Kenna", numberOfWins: 9),
    LeaderboardEntry(playerName: "Dan", numberOfWins: 8),
    LeaderboardEntry(playerName: "Thomas", numberOfWins: 7),
    LeaderboardEntry(playerName: "Bernie", numberOfWins: 6),
    LeaderboardEntry(playerName: "Caleb", numberOfWins: 5),
    LeaderboardEntry(playerName: "Riley", numberOfWins: 4),
    LeaderboardEntry(playerName: "Cole", numberOfWins: 3),
    LeaderboardEntry(playerName: "Aidan", numberOfWins: 2),
    LeaderboardEntry(playerName: "Person", numberOfWins: 1)
]
