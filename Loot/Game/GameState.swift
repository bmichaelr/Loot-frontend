//
//  GameState.swift
//  Loot
//
//  Created by Joshua on 4/1/24.
//

import Foundation

@Observable
class GameState: ObservableObject {
    enum GameplayError: Error {
        case playerNotFound
        case cardNotFound
        case helperFunctionError
    }
    var deck = Hand()
    var animationHandler = AnimationHandler()
    let stompClient: StompClient
    var gamePlayers: [GamePlayer] = []
    var gamePlayerMap: [UUID: GamePlayer] = [:]
    let roomKey: String
    let clientId: UUID
    let clientName: String
    init(players: [Player], stompClient: StompClient, roomKey: String, id: UUID, name: String) {
        self.stompClient = stompClient
        self.roomKey = roomKey
        self.clientId = id
        self.clientName = name
        for player in players {
            let gamePlayerObject = GamePlayer(from: player)
            if player.id == clientId {gamePlayerObject.isLocalPlayer = true}
            gamePlayers.append(gamePlayerObject)
            gamePlayerMap[player.id] = gamePlayerObject
        }
        addToDeck(Card(power: 0, faceDown: true))
    }
    func addToDeck(_ card: Card) {
        self.deck.cards.append(card)
    }
    func syncPlayers() {
        let player = Player(name: clientName, id: clientId)
        let request = LobbyRequest(player: player, roomKey: roomKey)
        stompClient.sendData(body: request, to: "/app/game/sync")
    }
    func handleStartRoundResponse(_ message: Data) {
        // Call the dealing animation and extract the card that pertains to specific player from payload
        print("got handle start round request")
        guard let response = try? JSONDecoder().decode(StartRoundResponse.self, from: message) else {
            print("Error getting the start round response")
            return
        }
        animationHandler.dealToAll(playerCardPair: response.playersAndCards, gamePlayers: gamePlayers, deck: deck) {
            self.syncPlayers()
        }
    }
    func handleNextTurnResponse(_ message: Data) {
        // Animate dealing card to player and if its us, show the card
        print("Got nextTurn resonse")
        guard let response = try? JSONDecoder().decode(NextTurnResponse.self, from: message) else {
            print("Error getting the start round response")
            return
        }
        guard let gamePlayer = gamePlayers.first(where: {$0.player.id == response.player.id}) else {
            print("Player not found")
            return
        }
        print("current turn: ", response.player.name)
        let gameCard = Card(from: response.card)
        if response.player.id == clientId {
            gameCard.faceDown = false
        }
        animationHandler.dealCard(card: gameCard, player: gamePlayer, deck: deck) {
            gamePlayer.isCurrentTurn = true
        }
    }
    func handleRoundStatusResponse(_ message: Data) {
        // Round over so show who won
    }
    func handlePlayedCardResponse(_ message: Data) {
        // Animate whoever played the card, discarding said card
        // Any other actions associated such as duck or rat (most complex)
        guard let response = try? JSONDecoder().decode(PlayedCardResponse.self, from: message) else {
            print("FATAL ERROR : Could not decode the PlayedCardResponse!")
            return
        }
        
        guard let (player, card) = try? getPlayerAndCard(fromResponse: response) else {
            print("FATAL ERROR : Could not find the player who played or their card!")
            return
        }
        // Play the card
        animationHandler.playCard(player: player, card: card)
        switch response.type.self {
        case .pottedPlant(let pottedResult):
            let outcome = pottedResult.outcome
            if outcome.correctGuess {
                guard let pair = try? getPlayerAndCard(fromPlayedOn: (outcome.playedOn, outcome.guessedCard)) else {
                    print("FATAL ERROR : Could not find the opponent or their card from potted result!")
                    return
                }
                animationHandler.playCard(player: pair.0, card: pair.1)
            }
            break
        case .maulRat(let maulRatResult):
            let outcome = maulRatResult.outcome
            guard let opPlayer = gamePlayers.first(where: {$0.player.id == outcome.playedOn.id}) else {
                print("Player not found in MaulRatResponse")
                return
            }
            guard let opCard = opPlayer.playerHand.cards.first(where: {$0.power == outcome.opponentsCard.power}) else {
                print("Card not found in maulRatResponse")
                return
            }
            animationHandler.sendToPlayer(from: opPlayer, to: player, card: opCard)
            animationHandler.sendToPlayer(from: player, to: opPlayer, card: opCard)
            break
        case .duckOfDoom(let duckOfDoomResult):
            let outcome = duckOfDoomResult.outcome
            // TODO: Animate the comparing, for now just going to discard the lesser hand
            if let playerToDiscard = outcome.playerToDiscard {
                let cardToDiscard = (outcome.playedOn.id == playerToDiscard.id) ? outcome.opponentCard : outcome.playersCard
                let player = gamePlayerMap[playerToDiscard.id]
                if player == nil {
                    print("FATAL ERROR : Unable to find the player to discard from duck of doom result.")
                    return
                }
                guard let foundCard = player!.playerHand.cards.first(where: { $0.power == cardToDiscard.power}) else {
                    print("FATAL ERROR : Unable to find the card to discard in duck of doom result!")
                    return
                }
                animationHandler.playCard(player: player!, card: foundCard)
            }
            break
        case .netTroll(let netTrollResult):
            let outcome = netTrollResult.outcome
            guard let pair = try? getPlayerAndCard(fromPlayedOn: (outcome.playedOn, outcome.discardedCard)) else {
                print("FATAL ERROR : Unable to find player or discarded card in NetTrollResult!")
                return
            }
            animationHandler.playCard(player: pair.0, card: pair.1)
            if let drawnCard = outcome.drawnCard {
                animationHandler.dealCard(card: Card(from: drawnCard), player: pair.0, deck: deck, completion: {})
            }
            break
        case .dreadGazebo(let dreadGazeboResult):
            let outcome = dreadGazeboResult.outcome
            guard let selfPair = try? getPlayerAndCard(fromPlayedOn: (response.playerWhoPlayed, outcome.playersCard)) else {
                print("FATAL ERROR : Unable to find the playing player and their card from DreadGazeboResponse!")
                return
            }
            guard let opPair = try? getPlayerAndCard(fromPlayedOn: (outcome.playedOn, outcome.opponentCard)) else {
                print("FATAL ERROR : Unable to find the playing player and their card from DreadGazeboResponse!")
                return
            }
            animationHandler.sendToPlayer(from: selfPair.0, to: opPair.0, card: selfPair.1)
            animationHandler.sendToPlayer(from: opPair.0, to: selfPair.0, card: opPair.1)
            break
        case .base(_):
            // TODO: update the player views and what not here
            print("Have a base card.")
        }
        syncPlayers()
    }
    private func getPlayerAndCard(fromResponse response: PlayedCardResponse? = nil, fromPlayedOn tuple: (Player, CardResponse)? = nil) throws -> (GamePlayer, Card) {
        if let response = response {
            guard let player = gamePlayerMap[response.playerWhoPlayed.id] else {
                throw GameplayError.playerNotFound
            }
            guard let card = player.playerHand.cards.first(where: {$0.power == response.cardPlayed.power}) else {
                throw GameplayError.cardNotFound
            }
            return (player, card)
        } else if let tuple = tuple {
            guard let player = gamePlayerMap[tuple.0.id] else {
                throw GameplayError.playerNotFound
            }
            guard let card = player.playerHand.cards.first(where: { $0.power == tuple.1.power }) else {
                throw GameplayError.cardNotFound
            }
            return (player, card)
        }
        throw GameplayError.helperFunctionError
    }
    func playNormalCard(gamePlayer: GamePlayer, card: Card) {
        let regularCard = RegularCard(power: card.power)
        let request = PlayCardRequest(roomKey: roomKey, player: gamePlayer.player, card: .regular(regularCard))
        stompClient.sendData(body: request, to: "/app/game/playCard")
    }
    func playGuessingCard(gamePlayer: GamePlayer, guessedOn: GamePlayer, card: Card, guessedCard: Int) {
        let guessingCard = GuessingCard(power: card.power, guessedOn: guessedOn.player, guessedCard: guessedCard)
        let request = PlayCardRequest(roomKey: roomKey, player: gamePlayer.player, card: .guessing(guessingCard))
        stompClient.sendData(body: request, to: "/app/game/playCard")
    }
    func playTargetCard(gamePlayer: GamePlayer, targetPlayer: GamePlayer, card: Card) {
        let targetCard = TargetedCard(power: card.power, playedOn: targetPlayer.player)
        let request = PlayCardRequest(roomKey: roomKey, player: gamePlayer.player, card: .targeted(targetCard))
        stompClient.sendData(body: request, to: "/app/game/playCard")
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
