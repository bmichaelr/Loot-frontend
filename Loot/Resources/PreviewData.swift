//
//  PreviewData.swift
//  Loot
//
//  Created by Benjamin Michael on 4/12/24.
//

import Foundation

var mainPlayer: Player = Player(name: "Bartholemew 1st", id: UUID())
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
