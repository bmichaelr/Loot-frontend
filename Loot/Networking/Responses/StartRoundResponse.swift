//
//  StartRoundResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 4/2/24.
//

import Foundation

struct StartRoundResponse: Codable {
    let playersAndCards: [PlayerCardPair]
    let cardKeptOut: CardResponse
}

struct PlayerCardPair: Codable {
    let player: Player
    let card: CardResponse
}
