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
        self.loadedIn = false
        self.ready = false
    }
    init(name: String, id: UUID, ready: Bool) {
        self.name = name
        self.id = id
        self.ready = ready
        self.isSafe = false
        self.loadedIn = false
    }
    let name: String
    let id: UUID
    let ready: Bool
    let isSafe: Bool
    let loadedIn: Bool
}
