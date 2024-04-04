//
//  CardRequests.swift
//  Loot
//
//  Created by Singontiko, Joshua on 4/4/24.
//

import Foundation
struct PlayCardRequest {
    let who: Player
    let playing: Any // will need similar things here like what card and specific metadata
}
struct RegularCard {
    let type: String = "personal"
    let power: Int
}
struct GuessingCard {
    let type: String = "guess"
    let power: Int
    let guessedOn: Player
    let guessedCard: Int
}
struct TargetedCard {
    let type: String = "targeted"
    let power: Int
    let playedOn: Player
}
