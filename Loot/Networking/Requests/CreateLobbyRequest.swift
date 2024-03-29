//
//  CreateLobbyRequest.swift
//  Loot
//
//  Created by Benjamin Michael on 3/29/24.
//

import Foundation

struct CreateLobbyRequest: Codable {
    let roomName: String
    let player: Player
}
