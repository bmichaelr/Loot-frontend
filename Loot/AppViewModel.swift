//
//  AppViewModel.swift
//  Loot
//
//  Created by Benjamin Michael on 3/13/24.
//

import Foundation

class AppViewModel: ObservableObject {
    let stompClient: StompClient = StompClient()
    @Published var playerName: String = ""
    @Published var connecting: Bool = false
    @Published var lobbyData: LobbyResponse = LobbyResponse()
    @Published var viewController: DisplayViewController = DisplayViewController.sharedViewDisplayController
    var firstLobbyLoad: Bool = true
    deinit {
        stompClient.swiftStomp.disconnect(force: true)
    }
    func connectToSocket() {
        self.connecting = true
        stompClient.connect(connected: { status in
            self.connecting = false
            if status {
                self.viewController.changeView(view: .homeMenuView)
            }
        })
    }
    func subscribeToMatchmakingChannels() {
        stompClient.registerListener("/topic/matchmaking/\(playerName)", using: handleLobbyResponse)
        stompClient.registerListener("/topic/error/\(playerName)", using: handleErrorResponse)
    }
    func unsubscribeFromMatchmakingChannels() {
        stompClient.unregisterListener("/topic/matchmaking/\(playerName)")
    }
    func subscribeToLobbyChannels() {
        stompClient.registerListener("/topic/lobby/\(lobbyData.roomKey)", using: handleLobbyResponse)
    }
    func unsubscribeFromLobbyChannels() {
        stompClient.unregisterListener("/topic/lobby/\(lobbyData.roomKey)")
    }
    func createGame() {
        let player = Player(name: playerName, id: Int.random(in: 0...150))
        let request = LobbyRequest(playerDto: player, roomKey: "")
        stompClient.sendData(body: request as LobbyRequest, to: "/app/createGame")
    }
    func joinGame(_ key: String) {
        let player = Player(name: playerName, id: Int.random(in: 150...200))
        let request = LobbyRequest(playerDto: player, roomKey: key)
        stompClient.sendData(body: request as LobbyRequest, to: "/app/joinGame")
    }
    func changeReadyStatus(_ ready: Bool) {
        let player = Player(name: playerName, id: Int.random(in: 150...200), ready: ready)
        let request = LobbyRequest(playerDto: player, roomKey: lobbyData.roomKey)
        stompClient.sendData(body: request as LobbyRequest, to: "/app/ready")
    }
    func handleLobbyResponse(_ message: Data) {
        do {
            let parsed = try JSONDecoder().decode(LobbyResponse.self, from: message)
            lobbyData.roomKey = parsed.roomKey
            lobbyData.players = parsed.players
            lobbyData.allReady = parsed.allReady
            print(lobbyData)
        } catch {
            print("Error decoding lobby response!")
        }
        if firstLobbyLoad {
            firstLobbyLoad = false
            viewController.changeView(view: .gameLobbyView)
        }
    }
    func handleErrorResponse(_ data: Data) {
        print("We got an error...")
    }
}
