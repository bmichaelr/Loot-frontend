//
//  RoundStatusResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 4/2/24.
//

import Foundation

struct RoundStatusResponse: Codable {
    let winner: Player
    let gameOver: Bool
    let roundOver: Bool
}
