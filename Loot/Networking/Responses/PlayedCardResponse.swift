//
//  PlayedCardResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 4/2/24.
//

import Foundation

struct PlayedCardResponse: Codable {
    let playerWhoPlayed: Player
    let cardPlayed: CardResponse
    let waitFlag: Bool
    let outcome: Outcome
}
enum Outcome: Codable {
    case base(BaseResult)
    case potted(PottedResult)
    case maulRat(MaulRatResponse)
    case duck(DuckResponse)
    case netTroll(NetTrollResponse)
    case gazebo(GazeboResult)
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let baseResult = try? container.decode(BaseResult.self) {
            self = .base(baseResult)
        } else if let pottedResult = try? container.decode(PottedResult.self) {
            self = .potted(pottedResult)
        } else if let maulRatResponse = try? container.decode(MaulRatResponse.self) {
            self = .maulRat(maulRatResponse)
        } else if let duckResponse = try? container.decode(DuckResponse.self) {
            self = .duck(duckResponse)
        } else if let netTrollResponse = try? container.decode(NetTrollResponse.self) {
            self = .netTroll(netTrollResponse)
        } else if let gazeboResult = try? container.decode(GazeboResult.self) {
            self = .gazebo(gazeboResult)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid outcome")
        }
    }
}
struct BaseResult: Codable {
    let playedOn: Player
}
struct PottedResult: Codable {
    let playedOn: Player
    let guessedCard: CardResponse
    let correctGuess: Bool
}
struct MaulRatResponse: Codable {
    let playedOn: Player
    let opponentsCard: CardResponse
}
struct DuckResponse: Codable {
    let playedOn: Player
    let opponentCard: CardResponse
    let playersCard: CardResponse
    let playerToDiscard: Player?
}
struct NetTrollResponse: Codable {
    let playedOn: Player
    let discardedCard: CardResponse
    let drawnCard: CardResponse?
}
struct GazeboResult: Codable {
    let playedOn: Player
    let opponentCard: CardResponse
    let playersCard: CardResponse
}
