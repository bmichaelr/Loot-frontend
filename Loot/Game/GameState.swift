//
//  GameState.swift
//  Loot
//
//  Created by Joshua on 4/1/24.
//

import Foundation
import SwiftUI

class GameState: ObservableObject {
    @Published var players = [GamePlayer]()
    @Published var me: GamePlayer?
    @Published var deck = Hand()
    @Published var myId: UUID
    @Published var showCard: Bool = false
    @Published var playCard: Bool = false
    @Published var myTurn: Bool = false
    @Published var cardToShow: Card = Card(number: 5)
    @Published var message: String = ""
    @Published var showCompareCards = false
    @Published var cardsToCompare = [Card]()
    var roomKey: String
    var stompClient: StompClient
    init(players: [Player], myId: UUID, roomKey: String, stompClient: StompClient) {
        self.myId = myId
        self.roomKey = roomKey
        self.stompClient = stompClient
        if let mePlayer = players.first(where: { $0.id == myId }) {
            self.me = GamePlayer(from: mePlayer)
        } else {
            fatalError("Player with specified ID not found")
        }
        self.players = players
            .filter { $0.id != myId }
            .map { GamePlayer(from: $0) }
        self.deck.cards.append(Card(number: 0))
        self.deck.cards.append(Card(number: 0))
    }
    func getPlayer(from id: UUID) -> GamePlayer? {
        if id == me!.clientId {
            return me!
        }
        return players.first(where: { $0.clientId == id})
    }
    func getCardFromPlayer(from player: GamePlayer, card: CardResponse) -> Card? {
        player.getHand(type: .holding).cards.first(where: {$0.number == card.power })
    }
    func dealCard(to hand: Hand, card: Card, onComplete: (() -> Void)? = nil) {
        deck.cards.append(card)
        withAnimation {
            guard let index = deck.cards.firstIndex(of: card) else {
                print("Could not find card in deck!")
                return
            }
            let dealtCard = deck.cards.remove(at: index)
            hand.cards.append(dealtCard)
        } completion: {
            if let function = onComplete {
                function()
            }
        }
    }
    func remove(card: Card, from hand: Hand) {
        withAnimation {
            guard let index = hand.cards.firstIndex(of: card) else {
                fatalError("Failed to find tapped card in hand")
            }
            hand.cards.remove(at: index)
            deck.cards.append(card)
        }
    }
    func discard(card: Card, from hand: Hand, to pile: Hand) {
        withAnimation {
            guard let index = hand.cards.firstIndex(of: card) else {
                fatalError("oops")
            }
            hand.cards.remove(at: index)
            pile.cards.append(card)
        } completion: {
            withAnimation {
                card.faceDown = false
            }
        }
    }
    func cleanUpCards() {
        for player in players {
            for hand in player.hands {
                for card in hand.cards {
                    remove(card: card, from: hand)
                }
            }
        }
        for hand in me!.hands {
            for card in hand.cards {
                remove(card: card, from: hand)
            }
        }
        deck.cards.append(Card(number: 0))
    }
    func showCard(card: Card) {
        cardToShow = card
        showCard = true
    }
    func playCard(card: Card) {
        cardToShow = card
        playCard = true
    }
    func getPlayerOptions(for card: Int) -> [String] {
        var options = [String]()
        for player in players {
            if !player.isSafe || !player.isOut {
                options.append(player.name)
            }
        }
        if card == 5 || options.count == 0 {
            options.append(me!.name)
        }
        return options
    }
    func getCardOptions(for power: Int) -> [String] {
        var options = [String]()
        options.append(contentsOf: [
            "Maul Rat",
            "Duck of Doom",
            "Wishing Ring",
            "Net Troll",
            "Dread Gazebo",
            "Turbonium Dragon",
            "Loot"
        ])
        return options
    }
    func playCard(player playerName: String, card cardName: String, play card: Card) {
        print("Playing card: \(card.number)")
        if playerName.isNotEmpty() {
            if cardName.isNotEmpty() {
                playGuessingCard(playerName, cardName, card)
            } else {
                playTargetedCard(playerName, card)
            }
        } else {
            let playing = Player(name: me!.name, id: me!.clientId)
            let regularCard = RegularCard(power: card.number)
            let request = PlayCardRequest(roomKey: roomKey, player: playing, card: .regular(regularCard))
            stompClient.sendData(body: request, to: "/app/game/playCard")
        }
        myTurn = false
    }
    private func playGuessingCard(_ playerName: String, _ cardName: String, _ card: Card) {
        guard let playedOn = getPlayerFromName(playerName) else {
            print("Unable to find player from given name!")
            return
        }
        guard let guessedCard = getCardNumberFromName(cardName) else {
            print("Unable to find card from given name!")
            return
        }
        let playing = Player(name: me!.name, id: me!.clientId)
        let guessedOn = Player(name: playedOn.name, id: playedOn.clientId)
        let guessingCard = GuessingCard(power: card.number, guessedOn: guessedOn, guessedCard: guessedCard)
        let request = PlayCardRequest(roomKey: roomKey, player: playing, card: .guessing(guessingCard))
        stompClient.sendData(body: request, to: "/app/game/playCard")
    }
    private func playTargetedCard(_ playerName: String, _ card: Card) {
        guard let player = getPlayerFromName(playerName) else {
            print("Unable to find player from given name!")
            return
        }
        let playing = Player(name: me!.name, id: me!.clientId)
        let playedOn = Player(name: player.name, id: player.clientId)
        let targetedCard = TargetedCard(power: card.number, playedOn: playedOn)
        let request = PlayCardRequest(roomKey: roomKey, player: playing, card: .targeted(targetedCard))
        stompClient.sendData(body: request, to: "/app/game/playCard")
    }
    private func getCardNumberFromName(_ name: String) -> Int? {
        switch name {
        case "Maul Rat": return 2
        case "Duck of Doom": return 3
        case "Wishing Ring": return 4
        case "Net Troll": return 5
        case "Dread Gazebo": return 6
        case "Turbonium Dragon": return 7
        case "Loot": return 8
        default: return nil
        }
    }
    private func getPlayerFromName(_ name: String) -> GamePlayer? {
        if me!.name == name {
            return me!
        }
        guard let player = players.first(where: { $0.name == name }) else {
            return nil
        }
        return player
    }
    // -- MARK: Handling functions for server
    func handleStartRoundResponse(_ message: Data) {
        self.message = "Starting the game!"
        print("got handle start round request")
        guard let response = try? JSONDecoder().decode(StartRoundResponse.self, from: message) else {
            print("Error getting the start round response")
            return
        }
        func dealStartingCard(for index: Int, list: [PlayerCardPair]) {
            if index >= list.count { return }
            guard let player = getPlayer(from: list[index].player.id) else {
                print("Unable to find player from id in start round response!")
                return
            }
            let card = Card(from: list[index].card)
            if player.clientId == me!.clientId {
                card.faceDown = false
            }
            dealCard(to: player.getHand(type: .holding), card: card) {
                dealStartingCard(for: index + 1, list: list)
            }
        }
        dealStartingCard(for: 0, list: response.playersAndCards)
        syncPlayers()
    }
    func handleNextTurnResponse(_ message: Data) {
        print("Recieved a next turn response!")
        guard let response = try? JSONDecoder().decode(NextTurnResponse.self, from: message) else {
            print("Unable to decode the next turn response!")
            return
        }
        self.message = "It is now \(response.player.name)'s turn!"
        if response.player.id == me!.clientId {
            myTurn = true
        }
        guard let player = getPlayer(from: response.player.id) else {
            print("Unable to find player from id in start round response!")
            return
        }
        let card = Card(from: response.card)
        if player.clientId == me!.clientId {
            card.faceDown = false
        }
        player.updatePlayer(with: response.player)
        dealCard(to: player.getHand(type: .holding), card: card)
    }
    func handleRoundStatusResponse(_ message: Data) {
        print("Recieved a handle round status response!")
        // TODO: show message of who one, and give them a token
        cleanUpCards()
        syncPlayers()
    }
    func handlePlayedCardResponse(_ message: Data) {
        guard let response = try? JSONDecoder().decode(PlayedCardResponse.self, from: message) else {
            print("FATAL ERROR : Could not decode the PlayedCardResponse!")
            return
        }
        self.message = "\(response.playerWhoPlayed.name) just played \(response.cardPlayed.name)"
        guard let playerWhoPlayed = getPlayer(from: response.playerWhoPlayed.id) else {
            print("Unable to find the player that played! (start round response)")
            return
        }
        guard let card = getCardFromPlayer(from: playerWhoPlayed, card: response.cardPlayed) else {
            print("Unable to find card from card played in handle played card response")
            return
        }
        discard(card: card, from: playerWhoPlayed.getHand(type: .holding), to: playerWhoPlayed.getHand(type: .discard))
        switch response.type.self {
        case .pottedPlant(let pottedResult):
            let outcome = pottedResult.outcome
            handlePottedResult(playing: playerWhoPlayed, result: outcome)
        case .maulRat(let maulRatResult):
            let outcome = maulRatResult.outcome
            handleMaulRatResult(playing: playerWhoPlayed, result: outcome)
        case .duckOfDoom(let duckOfDoomResult):
            let outcome = duckOfDoomResult.outcome
            handleDuckOfDoomResult(playing: playerWhoPlayed, result: outcome)
        case .netTroll(let netTrollResult):
            let outcome = netTrollResult.outcome
            handleNetTrollResult(playing: playerWhoPlayed, result: outcome)
        case .dreadGazebo(let dreadGazeboResult):
            let outcome = dreadGazeboResult.outcome
            handleDreadGazeboResult(playing: playerWhoPlayed, result: outcome)
        case .base:
            print("Have a base card.")
        }
        playerWhoPlayed.updatePlayer(with: response.playerWhoPlayed)
        syncPlayers()
    }
    private func handlePottedResult(playing: GamePlayer, result: PottedPlantResult) {
        if result.correctGuess {
            guard let guessedOn = getPlayer(from: result.playedOn.id) else {
                print("Unable to find guessed on player!")
                return
            }
            guard let guessedCard = getCardFromPlayer(from: guessedOn, card: result.guessedCard) else {
                print("Unable to find guessed card!")
                return
            }
            discard(card: guessedCard, from: guessedOn.getHand(type: .holding), to: guessedOn.getHand(type: .discard))
            guessedOn.updatePlayer(with: result.playedOn)
        }
    }
    private func handleMaulRatResult(playing: GamePlayer, result: MaulRatResult) {
        
    }
    private func handleDuckOfDoomResult(playing: GamePlayer, result: DuckOfDoomResult) {
        guard let playersCard = getCardFromPlayer(from: playing, card: result.playersCard) else {
            print("Unable to find players card in duck result")
            return
        }
        guard let opponent = getPlayer(from: result.playedOn.id) else {
            print("Unable to find opponent")
            return
        }
        guard let opponentsCard = getCardFromPlayer(from: opponent, card: result.opponentCard) else {
            print("Unable to find opponents card in duck result")
            return
        }
        // TODO: Josh compare the cards here
        if let playerToDiscard = result.playerToDiscard {
            if playerToDiscard.id == playing.clientId {
                discard(card: playersCard, from: playing.getHand(type: .holding), to: playing.getHand(type: .discard))
            } else {
                discard(card: opponentsCard, from: opponent.getHand(type: .holding), to: opponent.getHand(type: .discard))
            }
        }
    }
    private func handleNetTrollResult(playing: GamePlayer, result: NetTrollResult) {
        guard let playedOn = getPlayer(from: result.playedOn.id) else {
            print("Unable to find the played on player for net troll result!")
            return
        }
        guard let discardedCard = getCardFromPlayer(from: playedOn, card: result.discardedCard) else {
            print("Unable to find the discarded card from player in net troll resul!")
            return
        }
        discard(card: discardedCard, from: playedOn.getHand(type: .holding), to: playedOn.getHand(type: .discard))
        if let drawnCard = result.drawnCard {
            dealCard(to: playedOn.getHand(type: .holding), card: Card(from: drawnCard))
        }
    }
    private func handleDreadGazeboResult(playing: GamePlayer, result: DreadGazeboResult) {
        guard let playedOn = getPlayer(from: result.playedOn.id) else {
            print("Unable to find played on player in dread gazebo result")
            return
        }
        guard let opponentCard = getCardFromPlayer(from: playedOn, card: result.opponentCard) else {
            print("Unable to find opponent card in dread gazebo result")
            return
        }
        guard let otherCard = getCardFromPlayer(from: playing, card: result.playersCard) else {
            print("Unable to find players card that they have from gazebo result")
            return
        }
        discard(card: opponentCard, from: playedOn.getHand(type: .holding), to: playing.getHand(type: .holding))
        discard(card: otherCard, from: playing.getHand(type: .holding), to: playedOn.getHand(type: .holding))
    }
}

extension String {
    func isNotEmpty() -> Bool {
        return !self.isEmpty
    }
}

extension GameState {
    // -- MARK: Networking calls
    func syncPlayers() {
        let player = Player(name: me!.name, id: me!.id)
        let request = LobbyRequest(player: player, roomKey: roomKey)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stompClient.sendData(body: request, to: "/app/game/sync")
        }
    }
    func subscribeToGameChannels() {
        stompClient.registerListener("/topic/game/startRound/\(roomKey)", using: handleStartRoundResponse)
        stompClient.registerListener("/topic/game/nextTurn/\(roomKey)", using: handleNextTurnResponse)
        stompClient.registerListener("/topic/game/roundStatus/\(roomKey)", using: handleRoundStatusResponse)
        stompClient.registerListener("/topic/game/turnStatus/\(roomKey)", using: handlePlayedCardResponse)
    }
    func unsubscribeFromGameChannels() {
        stompClient.unregisterListener("/topic/game/startRound/\(roomKey)")
        stompClient.unregisterListener("/topic/game/nextTurn/\(roomKey)")
        stompClient.unregisterListener("/topic/game/roundStatus/\(roomKey)")
        stompClient.unregisterListener("/topic/game/turnStatus/\(roomKey)")
    }
}

//
//@Observable
//class GameState: ObservableObject {
//    enum GameplayError: Error {
//        case playerNotFound
//        case cardNotFound
//        case helperFunctionError
//    }
//    var deck = Hand()
//    var animationHandler = AnimationHandler()
//    let stompClient: StompClient
//    var gamePlayers: [GamePlayer] = []
//    var gamePlayerMap: [UUID: GamePlayer] = [:]
//    let roomKey: String
//    let clientId: UUID
//    let clientName: String
//    init(players: [Player], stompClient: StompClient, roomKey: String, id: UUID, name: String) {
//        self.stompClient = stompClient
//        self.roomKey = roomKey
//        self.clientId = id
//        self.clientName = name
//        for player in players {
//            let gamePlayerObject = GamePlayer(from: player)
//            if player.id == clientId {gamePlayerObject.isLocalPlayer = true}
//            gamePlayers.append(gamePlayerObject)
//            gamePlayerMap[player.id] = gamePlayerObject
//        }
//        addToDeck(Card(power: 0, faceDown: true))
//    }
//    func addToDeck(_ card: Card) {
//        self.deck.cards.append(card)
//    }
//    func syncPlayers() {
//        let player = Player(name: clientName, id: clientId)
//        let request = LobbyRequest(player: player, roomKey: roomKey)
//        stompClient.sendData(body: request, to: "/app/game/sync")
//    }
//    func handleStartRoundResponse(_ message: Data) {
//        // Call the dealing animation and extract the card that pertains to specific player from payload
//        print("got handle start round request")
//        guard let response = try? JSONDecoder().decode(StartRoundResponse.self, from: message) else {
//            print("Error getting the start round response")
//            return
//        }
//        animationHandler.dealToAll(playerCardPair: response.playersAndCards, gamePlayers: gamePlayers, deck: deck) {
//            self.syncPlayers()
//        }
//    }
//    func handleNextTurnResponse(_ message: Data) {
//        // Animate dealing card to player and if its us, show the card
//        print("Got nextTurn resonse")
//        guard let response = try? JSONDecoder().decode(NextTurnResponse.self, from: message) else {
//            print("Error getting the start round response")
//            return
//        }
//        guard let gamePlayer = gamePlayers.first(where: {$0.player.id == response.player.id}) else {
//            print("Player not found")
//            return
//        }
//        print("current turn: ", response.player.name)
//        let gameCard = Card(from: response.card)
//        if response.player.id == clientId {
//            gameCard.faceDown = false
//        }
//        animationHandler.dealCard(card: gameCard, player: gamePlayer, deck: deck) {
//            gamePlayer.isCurrentTurn = true
//        }
//    }
//    func handleRoundStatusResponse(_ message: Data) {
//        // Round over so show who won
//        for player in gamePlayers {
//            for card in player.playerHand.cards {
//                animationHandler.sendToDeckFromHand(player: player, card: card, deck: deck)
//            }
//            for card in player.playerPlayedCards.cards {
//                animationHandler.sendToDeckFromPlayed(player: player, card: card, deck: deck)
//            }
//        }
//    }
//    func handlePlayedCardResponse(_ message: Data) {
//        // Animate whoever played the card, discarding said card
//        // Any other actions associated such as duck or rat (most complex)
//        guard let response = try? JSONDecoder().decode(PlayedCardResponse.self, from: message) else {
//            print("FATAL ERROR : Could not decode the PlayedCardResponse!")
//            return
//        }
//        
//        guard let (player, card) = try? getPlayerAndCard(fromResponse: response) else {
//            print("FATAL ERROR : Could not find the player who played or their card!")
//            return
//        }
//        // Play the card
//        animationHandler.playCard(player: player, card: card)
//        switch response.type.self {
//        case .pottedPlant(let pottedResult):
//            let outcome = pottedResult.outcome
//            if outcome.correctGuess {
//                guard let pair = try? getPlayerAndCard(fromPlayedOn: (outcome.playedOn, outcome.guessedCard)) else {
//                    print("FATAL ERROR : Could not find the opponent or their card from potted result!")
//                    return
//                }
//                animationHandler.playCard(player: pair.0, card: pair.1)
//            }
//            break
//        case .maulRat(let maulRatResult):
//            let outcome = maulRatResult.outcome
//            guard let opPlayer = gamePlayers.first(where: {$0.player.id == outcome.playedOn.id}) else {
//                print("Player not found in MaulRatResponse")
//                return
//            }
//            guard let opCard = opPlayer.playerHand.cards.first(where: {$0.power == outcome.opponentsCard.power}) else {
//                print("Card not found in maulRatResponse")
//                return
//            }
//            animationHandler.sendToPlayer(from: opPlayer, to: player, card: opCard)
//            animationHandler.sendToPlayer(from: player, to: opPlayer, card: opCard)
//            break
//        case .duckOfDoom(let duckOfDoomResult):
//            let outcome = duckOfDoomResult.outcome
//            // TODO: Animate the comparing, for now just going to discard the lesser hand
//            if let playerToDiscard = outcome.playerToDiscard {
//                let cardToDiscard = (outcome.playedOn.id == playerToDiscard.id) ? outcome.opponentCard : outcome.playersCard
//                let player = gamePlayerMap[playerToDiscard.id]
//                if player == nil {
//                    print("FATAL ERROR : Unable to find the player to discard from duck of doom result.")
//                    return
//                }
//                guard let foundCard = player!.playerHand.cards.first(where: { $0.power == cardToDiscard.power}) else {
//                    print("FATAL ERROR : Unable to find the card to discard in duck of doom result!")
//                    return
//                }
//                animationHandler.playCard(player: player!, card: foundCard)
//            }
//            break
//        case .netTroll(let netTrollResult):
//            let outcome = netTrollResult.outcome
//            guard let pair = try? getPlayerAndCard(fromPlayedOn: (outcome.playedOn, outcome.discardedCard)) else {
//                print("FATAL ERROR : Unable to find player or discarded card in NetTrollResult!")
//                return
//            }
//            animationHandler.playCard(player: pair.0, card: pair.1)
//            if let drawnCard = outcome.drawnCard {
//                animationHandler.dealCard(card: Card(from: drawnCard), player: pair.0, deck: deck, completion: {})
//            }
//            break
//        case .dreadGazebo(let dreadGazeboResult):
//            let outcome = dreadGazeboResult.outcome
//            guard let selfPair = try? getPlayerAndCard(fromPlayedOn: (response.playerWhoPlayed, outcome.playersCard)) else {
//                print("FATAL ERROR : Unable to find the playing player and their card from DreadGazeboResponse!")
//                return
//            }
//            guard let opPair = try? getPlayerAndCard(fromPlayedOn: (outcome.playedOn, outcome.opponentCard)) else {
//                print("FATAL ERROR : Unable to find the playing player and their card from DreadGazeboResponse!")
//                return
//            }
//            animationHandler.sendToPlayer(from: selfPair.0, to: opPair.0, card: selfPair.1)
//            animationHandler.sendToPlayer(from: opPair.0, to: selfPair.0, card: opPair.1)
//            break
//        case .base(_):
//            // TODO: update the player views and what not here
//            print("Have a base card.")
//        }
//        syncPlayers()
//    }
//    private func getPlayerAndCard(fromResponse response: PlayedCardResponse? = nil, fromPlayedOn tuple: (Player, CardResponse)? = nil) throws -> (GamePlayer, Card) {
//        if let response = response {
//            guard let player = gamePlayerMap[response.playerWhoPlayed.id] else {
//                throw GameplayError.playerNotFound
//            }
//            guard let card = player.playerHand.cards.first(where: {$0.power == response.cardPlayed.power}) else {
//                throw GameplayError.cardNotFound
//            }
//            return (player, card)
//        } else if let tuple = tuple {
//            guard let player = gamePlayerMap[tuple.0.id] else {
//                throw GameplayError.playerNotFound
//            }
//            guard let card = player.playerHand.cards.first(where: { $0.power == tuple.1.power }) else {
//                throw GameplayError.cardNotFound
//            }
//            return (player, card)
//        }
//        throw GameplayError.helperFunctionError
//    }
//    func playNormalCard(gamePlayer: GamePlayer, card: Card) {
//        let regularCard = RegularCard(power: card.power)
//        let request = PlayCardRequest(roomKey: roomKey, player: gamePlayer.player, card: .regular(regularCard))
//        stompClient.sendData(body: request, to: "/app/game/playCard")
//    }
//    func playGuessingCard(gamePlayer: GamePlayer, guessedOn: GamePlayer, card: Card, guessedCard: Int) {
//        let guessingCard = GuessingCard(power: card.power, guessedOn: guessedOn.player, guessedCard: guessedCard)
//        let request = PlayCardRequest(roomKey: roomKey, player: gamePlayer.player, card: .guessing(guessingCard))
//        stompClient.sendData(body: request, to: "/app/game/playCard")
//    }
//    func playTargetCard(gamePlayer: GamePlayer, targetPlayer: GamePlayer, card: Card) {
//        let targetCard = TargetedCard(power: card.power, playedOn: targetPlayer.player)
//        let request = PlayCardRequest(roomKey: roomKey, player: gamePlayer.player, card: .targeted(targetCard))
//        stompClient.sendData(body: request, to: "/app/game/playCard")
//    }
//
//    func subscribeToGameChannels() {
//        stompClient.registerListener("/topic/game/startRound/\(roomKey)", using: handleStartRoundResponse)
//        stompClient.registerListener("/topic/game/nextTurn/\(roomKey)", using: handleNextTurnResponse)
//        stompClient.registerListener("/topic/game/roundStatus/\(roomKey)", using: handleRoundStatusResponse)
//        stompClient.registerListener("/topic/game/turnStatus/\(roomKey)", using: handlePlayedCardResponse)
//    }
//    func unsubscribeFromGameChannels() {
//        stompClient.unregisterListener("/topic/game/startRound/\(roomKey)")
//        stompClient.unregisterListener("/topic/game/nextTurn/\(roomKey)")
//        stompClient.unregisterListener("/topic/game/roundStatus/\(roomKey)")
//        stompClient.unregisterListener("/topic/game/turnStatus/\(roomKey)")
//    }
//}
