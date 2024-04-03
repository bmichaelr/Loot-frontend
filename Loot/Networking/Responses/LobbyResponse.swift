//
//  LobbyResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 3/13/24.
//

import Foundation

struct LobbyResponse: Codable {
    var roomKey: String
    var name: String
    var players: [Player]
    var allReady: Bool
    init() {
        self.roomKey = ""
        self.name = ""
        self.players = []
        self.allReady = false
    }
}
