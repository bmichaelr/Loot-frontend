import Foundation

struct PlayedCardResponse: Decodable {
    let playerWhoPlayed: Player
    let cardPlayed: CardResponse
    let waitFlag: Bool
    let type: Result
    enum CodingKeys: String, CodingKey {
        case playerWhoPlayed, cardPlayed, waitFlag, type
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.playerWhoPlayed = try container.decode(Player.self, forKey: .playerWhoPlayed)
        self.cardPlayed = try container.decode(CardResponse.self, forKey: .cardPlayed)
        self.waitFlag = try container.decode(Bool.self, forKey: .waitFlag)
        self.type = try .init(from: decoder)
    }
}
enum Result: Decodable {
    case pottedPlant(PottedPlant), maulRat(MaulRat), duckOfDoom(DuckOfDoom)
    case netTroll(NetTroll), dreadGazebo(DreadGazebo), base(Base)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ResultType.self, forKey: .type)
        switch type {
        case .base:
            self = .base(try Base(from: decoder))
        case .pottedPlant:
            self = .pottedPlant(try PottedPlant(from: decoder))
        case .maulRat:
            self = .maulRat(try MaulRat(from: decoder))
        case .duckOfDoom:
            self = .duckOfDoom(try DuckOfDoom(from: decoder))
        case .netTroll:
            self = .netTroll(try NetTroll(from: decoder))
        case .dreadGazebo:
            self = .dreadGazebo(try DreadGazebo(from: decoder))
        }
    }
    enum CodingKeys: String, CodingKey {
        case type
    }
    enum ResultType: String, Decodable {
        case base
        case pottedPlant
        case maulRat
        case duckOfDoom
        case netTroll
        case dreadGazebo
    }
}
struct Base: Codable {
    let outcome: BaseResult
}
struct BaseResult: Codable {
    let playedOn: Player
}
struct PottedPlant: Codable {
    let outcome: PottedPlantResult
}
struct PottedPlantResult: Codable {
    let playedOn: Player
    let guessedCard: CardResponse
    let correctGuess: Bool
}
struct MaulRat: Codable {
    let outcome: MaulRatResult
}
struct MaulRatResult: Codable {
    let playedOn: Player
    let opponentsCard: CardResponse
}
struct DuckOfDoom: Codable {
    let outcome: DuckOfDoomResult
}
struct DuckOfDoomResult: Codable {
    let playedOn: Player
    let opponentCard: CardResponse
    let playersCard: CardResponse
    let playerToDiscard: Player?
}
struct NetTroll: Codable {
    let outcome: NetTrollResult
}
struct NetTrollResult: Codable {
    let playedOn: Player
    let discardedCard: CardResponse
    let drawnCard: CardResponse?
}
struct DreadGazebo: Codable {
    let outcome: DreadGazeboResult
}
struct DreadGazeboResult: Codable {
    let playedOn: Player
    let opponentCard: CardResponse
    let playersCard: CardResponse
}
