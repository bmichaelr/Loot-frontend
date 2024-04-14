//
//  CardRequests.swift
//  Loot
//
//  Created by Singontiko, Joshua on 4/4/24.
//

import Foundation

enum CardType: String, Codable {
    case regular = "personal"
    case guessing = "guess"
    case targeted = "targeted"
}

protocol CardProtocol: Codable {
    var type: CardType { get }
    var power: Int { get }
}

struct RegularCard: CardProtocol {
    var type: CardType = .regular
    let power: Int
}

struct GuessingCard: CardProtocol {
    var type: CardType = .guessing
    let power: Int
    let guessedOn: Player
    let guessedCard: Int
}

struct TargetedCard: CardProtocol {
    var type: CardType = .targeted
    let power: Int
    let playedOn: Player
}

struct PlayCardRequest: Codable {
    let roomKey: String
    let player: Player
    let card: CardWrapper
}

enum CardWrapper: Codable {
    case regular(RegularCard)
    case guessing(GuessingCard)
    case targeted(TargetedCard)
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .regular(let card):
            try container.encode(card)
        case .guessing(let card):
            try container.encode(card)
        case .targeted(let card):
            try container.encode(card)
        }
    }
}
