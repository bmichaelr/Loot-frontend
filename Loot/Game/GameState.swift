//
//  GameState.swift
//  Loot
//
//  Created by Joshua on 4/1/24.
//

import Foundation

@Observable
class GameState: ObservableObject {
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
            print("Error getting the start round response")
            return
        }
        guard let gamePlayer = gamePlayers.first(where: {$0.player.id == response.playerWhoPlayed.id}) else {
            print("Player not found")
            return
        }
        guard let gameCard = gamePlayer.playerHand.cards.first(where: {$0.power == response.cardPlayed.power}) else {
            print("card not found")
            return
        }
        switch response.outcome {
        case .base(_):
            animationHandler.playCard(player: gamePlayer, card: gameCard)
            break
        case .potted(let pottedResult):
            // Play card, if correct, then other player is out
            break
        case .maulRat(let maulRatResult):
            animationHandler.playCard(player: gamePlayer, card: gameCard)
            guard let opPlayer = gamePlayers.first(where: {$0.player.id == maulRatResult.playedOn.id}) else {
                print("Player not found in MaulRatResponse")
                return
            }
            // Move opponents hand into this players hand, then move it back
            guard let playedCard = opPlayer.playerHand.cards.first(where: {$0.power == maulRatResult.opponentsCard.power}) else {
                print("Card not found in maulRatResponse")
                return
            }
            animationHandler.sendToPlayer(from: opPlayer, to: gamePlayer, card: playedCard)
            animationHandler.sendToPlayer(from: gamePlayer, to: opPlayer, card: playedCard)
        case .duck(_):
            // Two players compare hands
            break
        case .netTroll(let netTrollResult):
            // Picked player has to pick a new card
            guard let pickedPlayer = gamePlayers.first(where: {$0.player.id == netTrollResult.playedOn.id}) else {
                print("Player not found in MaulRatResponse")
                return
            }
            guard let pickedCard = pickedPlayer.playerHand.cards.first(where: {$0.power == netTrollResult.discardedCard.power}) else {
                print("Card not found in netTrollResponse")
                return
            }
            animationHandler.playCard(player: pickedPlayer, card: pickedCard)
            if !pickedPlayer.player.isOut {
                animationHandler.dealCard(card: Card(from: netTrollResult.drawnCard!), player: pickedPlayer, deck: deck) {
                    //
                }
            }
        case .gazebo(_):
            break
        }
    }
    func playCard(gamePlayer: GamePlayer, card: Card) {
//        let player = Player(name: clientName, id: clientId)
//        let request = LobbyRequest(player: player, roomKey: roomKey)
//        stompClient.sendData(body: request, to: "/app/game/playCard")
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
