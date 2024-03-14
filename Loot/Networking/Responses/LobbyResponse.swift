//
//  LobbyResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 3/13/24.
//

import Foundation

struct LobbyResponse: Codable {
    var roomKey: String
    var players: [GamePlayer]
    var allReady: Bool
    init() {
        self.roomKey = ""
        self.players = []
        self.allReady = false
    }
}
struct GamePlayer: Codable {
    let id: CLong
    var ready: Bool
    var loadedIn: Bool
    var isSafe: Bool
    var name: String
}
