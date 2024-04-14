//
//  ServerResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 3/26/24.
//

import Foundation

struct ServerResponse: Codable {
    let name: String
    let key: String
    let maximumPlayers: Int
    let numberOfPlayers: Int
    let status: String
    // Function to check if the game is joinable. This is the only status string that
    // the server will return if it is able to be joined
    func isJoinable() -> Bool {
        return status == "Available"
    }
}
