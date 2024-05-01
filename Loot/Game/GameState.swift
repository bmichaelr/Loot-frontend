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
    @Published var me: GamePlayer
    @Published var deck = Hand()
    @Published var myId: UUID
    @Published var showCard: Bool = false
    @Published var playCard: Bool = false
    @Published var myTurn: Bool = false
    @Published var cardToShow: Card = Card(number: 5)
    @Published var gameLog: GameLog = GameLog()
    @Published var showCompareCards = false
    @Published var cardNamesToCompare = [CardNameStruct]()
    @Published var showPeekCard = false
    @Published var cardToPeek: Card = Card(number: 5)
    @Published var hasCoin: Bool = true
    @Published var winningCard: Card = Card(number: 5)
    @Published var showWinningView: Bool = false
    @Published var gameWinner = GamePlayer(from: Player(name: "", id: UUID()))
    @Published var outCardHand = Hand()
    @Published var roundNumber: Int = 0
    var displayViewController = DisplayedViewController.sharedViewDisplayController
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
    func leaveGame() {
        let player = Player(name: me.name, id: myId)
        let request = LobbyRequest(player: player, roomKey: roomKey)
        stompClient.sendData(body: request as LobbyRequest, to: "/app/leaveGame")
    }
    func getPlayer(from id: UUID) -> GamePlayer? {
        if id == me.clientId {
            return me
        }
        return players.first(where: { $0.clientId == id})
    }
    func getCardFromPlayer(from player: GamePlayer, card: CardResponse) -> Card? {
        player.getHand(type: .holding).cards.first(where: {$0.number == card.power })
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
            if !player.isSafe && !player.isOut {
                options.append(player.name)
            }
        }
        if card == 5 || options.count == 0 {
            options.append(me.name)
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
            let playing = Player(name: me.name, id: me.clientId)
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
        let playing = Player(name: me.name, id: me.clientId)
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
        let playing = Player(name: me.name, id: me.clientId)
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
        if me.name == name {
            return me
        }
        guard let player = players.first(where: { $0.name == name }) else {
            return nil
        }
        return player
    }
}
// Handle response extension
extension GameState {
    // -- MARK: Handling functions for server
    func handleStartRoundResponse(_ message: Data) {
        roundNumber += 1
        gameLog.newRound()
        guard let response = try? JSONDecoder().decode(StartRoundResponse.self, from: message) else {
            print("Error getting the start round response")
            return
        }
        let card = Card(from: response.cardKeptOut)
        deck.cards.append(card)
        withAnimation {
            guard let index = deck.cards.firstIndex(of: card) else {
                print("Could not find card in deck!")
                return
            }
            let dealtCard = deck.cards.remove(at: index)
            outCardHand.cards.append(dealtCard)
        }
        func dealStartingCard(for index: Int, list: [PlayerCardPair]) {
            if index >= list.count { return }
            guard let player = getPlayer(from: list[index].player.id) else {
                print("Unable to find player from id in start round response!")
                return
            }
            player.updatePlayer(with: list[index].player)
            let card = Card(from: list[index].card)
            if player.clientId == me.clientId {
                card.faceDown = false
            }
            dealCard(to: player, card: card) {
                dealStartingCard(for: index + 1, list: list)
            }
        }
        dealStartingCard(for: 0, list: response.playersAndCards)
        DispatchQueue.main.asyncAfter(deadline: .now() + (0.5 * (Double(players.count) + 1.0))) {
            self.syncPlayers()
        }
    }
    func handleNextTurnResponse(_ message: Data) {
        guard let response = try? JSONDecoder().decode(NextTurnResponse.self, from: message) else {
            print("Unable to decode the next turn response!")
            return
        }
        let log = "It is now \(response.player.name)'s turn!"
        gameLog.addMessage(text: log, type: .turnUpdate)
        if response.player.id == me.clientId {
            myTurn = true
        }
        guard let player = getPlayer(from: response.player.id) else {
            print("Unable to find player from id in start round response!")
            return
        }
        let card = Card(from: response.card)
        if player.clientId == me.clientId {
            card.faceDown = false
        }
        player.changeTurnStatus()
        player.updatePlayer(with: response.player)
        dealCard(to: player, card: card)
    }
    func handleRoundStatusResponse(_ message: Data) {
        guard let response = try? JSONDecoder().decode(RoundStatusResponse.self, from: message) else {
            print("Unable to decode the round status response!")
            return
        }
        gameLog.addMessage(text: "The round is over.", type: .roundOver)
        gameLog.roundOver(name: "\(response.winner.name)")
        guard let winner = getPlayer(from: response.winner.id) else {return}
        let gameOver = response.gameOver
        if gameOver {
            guard let winningCardFromResponse = response.winningCard else {
                print("Unable to obtain winning card from response")
                return
            }
            winningCard = Card(from: winningCardFromResponse)
            gameWinner = winner
            withAnimation {
                outCardHand.cards.forEach { card in
                    card.faceDown = false
                }
            } completion: {
                sleep(1)
                self.showWinningView = true
            }
            return
        }
        withAnimation {
            outCardHand.cards.forEach { card in
                card.faceDown = false
            }
        } completion: {
            self.outCardHand.cards.removeAll()
            winner.numberOfWins += 1
            winner.counter += 1
            sleep(UInt32(0.5))
            withAnimation {
                sleep(UInt32(0.5))
                self.hasCoin.toggle()
                winner.hasCoin.toggle()
            } completion: {
                winner.hasCoin = false
                self.hasCoin.toggle()
                sleep(UInt32(0.5))
                self.cleanUpCards()
                self.syncPlayers()
            }
        }
    }
    func handlePlayedCardResponse(_ message: Data) {
        guard let response = try? JSONDecoder().decode(PlayedCardResponse.self, from: message) else {
            print("FATAL ERROR : Could not decode the PlayedCardResponse!")
            return
        }
        guard let playerWhoPlayed = getPlayer(from: response.playerWhoPlayed.id) else {
            print("Unable to find the player that played! (start round response)")
            return
        }
        guard let card = getCardFromPlayer(from: playerWhoPlayed, card: response.cardPlayed) else {
            print("Unable to find card from card played in handle played card response")
            return
        }
        playerWhoPlayed.updatePlayer(with: response.playerWhoPlayed)
        discard(card: card, player: playerWhoPlayed)
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
            let log = "\(playerWhoPlayed.name) played \(card.name)"
            gameLog.addMessage(text: log, type: .cardPlayed)
            syncPlayers()
        }
        playerWhoPlayed.changeTurnStatus()
    }
    private func handlePottedResult(playing: GamePlayer, result: PottedPlantResult) {
        var msgBuilder = "\(playing.name) guessed \(result.guessedCard.name) on \(result.playedOn.name), they guessed "
        if result.correctGuess {
            guard let guessedOn = getPlayer(from: result.playedOn.id) else {
                print("Unable to find guessed on player!")
                return
            }
            guard let guessedCard = getCardFromPlayer(from: guessedOn, card: result.guessedCard) else {
                print("Unable to find guessed card!")
                return
            }
            msgBuilder.append("right! \(result.playedOn.name) is out.")
            discard(card: guessedCard, player: guessedOn)
            guessedOn.updatePlayer(with: result.playedOn)
        } else {
            msgBuilder.append("wrong")
        }
        gameLog.addMessage(text: msgBuilder, type: .cardPlayed)
        syncPlayers()
    }
    private func handleMaulRatResult(playing: GamePlayer, result: MaulRatResult) {
        guard let opponent = getPlayer(from: result.playedOn.id) else {
            print("unable to find opponent in mual rat")
            return
        }
        let log = "\(playing.name) played Maul Rat on \(opponent.name)"
        gameLog.addMessage(text: log, type: .cardPlayed)
        if me.clientId == playing.clientId {
            cardToPeek = Card(from: result.opponentsCard)
            showPeekCard = true
        } else {
            syncPlayers()
        }
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
        var log = "\(playing.name) played Duck of Doom on \(opponent.name). "
        if let playerToDiscard = result.playerToDiscard {
            if playerToDiscard.id == playing.clientId {
                log.append("\(playing.name) is out.")
                gameLog.addMessage(text: log, type: .cardPlayed)
                discard(card: playersCard, player: playing)
            } else {
                log.append("\(opponent.name) is out.")
                gameLog.addMessage(text: log, type: .cardPlayed)
                discard(card: opponentsCard, player: opponent)
            }
        } else {
            log.append("It's a tie, no one is out.")
            gameLog.addMessage(text: log, type: .cardPlayed)
        }
        opponent.updatePlayer(with: result.playedOn)
        if me.clientId == playing.clientId || me.clientId == opponent.clientId {
            cardNamesToCompare.append(CardNameStruct(card: playersCard, name: playing.name))
            cardNamesToCompare.append(CardNameStruct(card: opponentsCard, name: opponent.name))
            showCompareCards = true
        } else {
            syncPlayers()
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
        let log = "\(playing.name) played Net Troll on \(playedOn.name)"
        gameLog.addMessage(text: log, type: .cardPlayed)
        discard(card: discardedCard, player: playedOn)
        if let drawnCard = result.drawnCard {
            dealCard(to: playedOn, card: Card(from: drawnCard))
        }
        syncPlayers()
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
        let log = "\(playing.name) played Dread Gazebo on \(playedOn.name)"
        gameLog.addMessage(text: log, type: .cardPlayed)
        moveCard(card: opponentCard, from: playedOn, to: playing) {
            self.moveCard(card: otherCard, from: playing, to: playedOn)
        }
        syncPlayers()
    }
}

extension String {
    func isNotEmpty() -> Bool {
        return !self.isEmpty
    }
}
// -- MARK: Ping calls
extension GameState {
    func syncPlayers() {
        let player = Player(name: me.name, id: me.id)
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
// -- MARK: Animation Functions
extension GameState {
    func discard(card: Card, player: GamePlayer) {
        let holdingHand = player.getHand(type: .holding)
        let discardHand = player.getHand(type: .discard)
        withAnimation {
            guard let index = holdingHand.cards.firstIndex(of: card) else {
                fatalError("oops")
            }
            holdingHand.cards.remove(at: index)
            discardHand.cards.append(card)
        } completion: {
            withAnimation {
                card.faceDown = false
            }
        }
    }
    func moveCard(card: Card, from player1: GamePlayer, to player2: GamePlayer, onComplete: (() -> Void)? = nil) {
        let hand1 = player1.getHand(type: .holding)
        let hand2 = player2.getHand(type: .holding)
        withAnimation {
            guard let index = hand1.cards.firstIndex(of: card) else {
                fatalError("Could not find card to move")
            }
            hand1.cards.remove(at: index)
            hand2.cards.append(card)
        } completion: {
            if player2.clientId == self.me.clientId {
                withAnimation {
                    card.faceDown = false
                }
            } else {
                withAnimation {
                    card.faceDown = true
                }
            }
            if let onComplete = onComplete {
                onComplete()
            }
        }
    }
    func dealCard(to player: GamePlayer, card: Card, onComplete: (() -> Void)? = nil) {
        let hand = player.getHand(type: .holding)
        deck.cards.append(card)
        withAnimation {
            guard let index = deck.cards.firstIndex(of: card) else {
                print("Could not find card in deck!")
                return
            }
            let dealtCard = deck.cards.remove(at: index)
            hand.cards.append(dealtCard)
        } completion: {
            if player.clientId == self.me.clientId {
                card.faceDown = false
            }
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
    func cleanUpCards() {
        for player in players {
            for hand in player.hands {
                for card in hand.cards {
                    remove(card: card, from: hand)
                }
            }
        }
        for hand in me.hands {
            for card in hand.cards {
                remove(card: card, from: hand)
            }
        }
        deck.cards.append(Card(number: 0))
    }
}
