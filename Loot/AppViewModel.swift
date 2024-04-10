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
    @Published var serverList: [ServerResponse] = []
    @Published var viewController: DisplayedViewController = DisplayedViewController.sharedViewDisplayController
    var firstLobbyLoad: Bool = true
    let clientUUID: UUID = UUID.init()
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
        let id = clientUUID.uuidString.lowercased()
        stompClient.registerListener("/topic/matchmaking/servers/\(id)", using: handleServerListResponse)
        stompClient.registerListener("/topic/matchmaking/\(id)", using: handleLobbyResponse)
        stompClient.registerListener("/topic/error/\(id)", using: handleErrorResponse)
        stompClient.sendData(body: Player(name: playerName, id: clientUUID), to: "/app/loadAvailableServers")
    }
    func unsubscribeFromMatchmakingChannels() {
        stompClient.unregisterListener("/topic/matchmaking/\(clientUUID.uuidString.lowercased())")
    }
    func subscribeToLobbyChannels() {
        stompClient.registerListener("/topic/lobby/\(lobbyData.roomKey)", using: handleLobbyResponse)
    }
    func unsubscribeFromLobbyChannels() {
        stompClient.unregisterListener("/topic/lobby/\(lobbyData.roomKey)")
    }
    func reloadServerList() {
        let player = Player(name: playerName, id: clientUUID)
        stompClient.sendData(body: player, to: "/app/loadAvailableServers")
    }
    func createGame(_ roomName: String, _ players: Int, _ wins: Int) {
        let player = Player(name: playerName, id: clientUUID)
        let settings = GameSettings(roomName: roomName, numberOfPlayers: players, numberOfWinsNeeded: wins)
        let request = CreateLobbyRequest(settings: settings, player: player)
        stompClient.sendData(body: request as CreateLobbyRequest, to: "/app/createGame")
    }
    func joinGame(_ key: String) {
        let player = Player(name: playerName, id: clientUUID)
        let request = LobbyRequest(player: player, roomKey: key)
        stompClient.sendData(body: request as LobbyRequest, to: "/app/joinGame")
    }
    func leaveGame(_ key: String) {
        unsubscribeFromLobbyChannels()
        let player = Player(name: playerName, id: clientUUID)
        let request = LobbyRequest(player: player, roomKey: key)
        stompClient.sendData(body: request as LobbyRequest, to: "/app/leaveGame")
        self.lobbyData = LobbyResponse()
        self.firstLobbyLoad = true
        viewController.changeView(view: .homeMenuView)
    }
    func syncPlayers() {
        let player = Player(name: playerName, id: clientUUID)
        let request = LobbyRequest(player: player, roomKey: lobbyData.roomKey)
        stompClient.sendData(body: request, to: "/app/game/sync")
    }
    func changeReadyStatus(_ ready: Bool) {
        let player = Player(name: playerName, id: clientUUID, ready: ready)
        let request = LobbyRequest(player: player, roomKey: lobbyData.roomKey)
        stompClient.sendData(body: request as LobbyRequest, to: "/app/ready")
    }
    func handleLobbyResponse(_ message: Data) {
        do {
            let parsed = try JSONDecoder().decode(LobbyResponse.self, from: message)
            lobbyData = parsed
        } catch {
            print("Error decoding lobby response!")
        }
        if firstLobbyLoad {
            firstLobbyLoad = false
            viewController.changeView(view: .gameLobbyView)
        }
//        // HERE .....
//        if lobbyData.allReady {
//            unsubscribeFromLobbyChannels()
//            viewController.changeView(view: .gameView)
//            lobbyData.
//        }
    }
    func startGame() {
        if lobbyData.allReady {
            unsubscribeFromLobbyChannels()
            viewController.changeView(view: .gameView)
        }
    }

    func handleServerListResponse(_ message: Data) {
        do {
            let parsed = try JSONDecoder().decode([ServerResponse].self, from: message)
            serverList = parsed
        } catch {
            print("Unable to decode the server response")
        }
    }
    func handleErrorResponse(_ data: Data) {
        print("We got an error...")
    }
}
