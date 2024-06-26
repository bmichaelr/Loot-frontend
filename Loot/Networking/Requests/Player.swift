//
//  Player.swift
//  Loot
//
//  Created by Benjamin Michael on 3/13/24.
//

import Foundation

struct Player: Codable {
    init(name: String, id: UUID) {
        self.name = name
        self.id = id
        self.isSafe = false
        self.isOut = false
        self.ready = false
        self.isHost = false
    }
    init(name: String, id: UUID, ready: Bool) {
        self.name = name
        self.id = id
        self.ready = ready
        self.isSafe = false
        self.isOut = false
        self.isHost = false
    }
    let id: UUID
    let name: String
    let ready: Bool
    let isSafe: Bool
    let isOut: Bool
    let isHost: Bool
}
