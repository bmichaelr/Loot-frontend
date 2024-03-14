//
//  LobbyRequest.swift
//  Loot
//
//  Created by Benjamin Michael on 3/13/24.
//

import Foundation

struct LobbyRequest: Codable {
    let playerDto: Player
    let roomKey: String
}
