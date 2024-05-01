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
        self.profileColor = "#000000"
        self.profilePicture = 2
    }
    init(name: String, id: UUID, ready: Bool) {
        self.name = name
        self.id = id
        self.ready = ready
        self.isSafe = false
        self.isOut = false
        self.isHost = false
        self.profileColor = "#000000"
        self.profilePicture = 2
    }
    init(profile: Profile, id: UUID, ready: Bool) {
        self.id = id
        self.name = profile.name
        self.profileColor = profile.background
        self.profilePicture = profile.imageNum
        self.ready = ready
        self.isSafe = false
        self.isOut = false
        self.isHost = false
    }
    let id: UUID
    let name: String
    let profilePicture: Int
    let profileColor: String
    let ready: Bool
    let isSafe: Bool
    let isOut: Bool
    let isHost: Bool
}
