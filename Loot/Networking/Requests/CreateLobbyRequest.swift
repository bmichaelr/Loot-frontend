//
//  CreateLobbyRequest.swift
//  Loot
//
//  Created by Benjamin Michael on 3/29/24.
//

import Foundation

struct CreateLobbyRequest: Codable {
    let settings: GameSettings
    let player: Player
}

struct GameSettings: Codable {
    let roomName: String
    let numberOfPlayers: Int
    let numberOfWinsNeeded: Int
}
