//
//  NextTurnResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 4/2/24.
//

import Foundation

struct NextTurnResponse: Codable {
    let player: Player
    let card: CardResponse
}
