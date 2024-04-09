//
//  LootApp.swift
//  Loot
//
//  Created by Benjamin Michael on 2/25/24.
//

import SwiftUI

@main
struct LootApp: App {
    @ObservedObject var displayViewController = DisplayedViewController.sharedViewDisplayController
    @ObservedObject var model: AppViewModel = AppViewModel()
    @State private var showCustomLoadingView: Bool = true
    var body: some Scene {
        WindowGroup {
            ZStack {
                if !showCustomLoadingView {
                    switch displayViewController.currentView {
                    case .gameLobbyView:
                        GameLobbyView()
                    case .homeMenuView:
                        MatchmakingView()
                    case .gameView:
                        GameView()
                            .environmentObject(
                                GameState(players: model.lobbyData.players, 
                                          myId: model.clientUUID, roomKey:
                                            model.lobbyData.roomKey,
                                          stompClient: model.stompClient)
                            )
                    case .startNewGameView:
                        ConnectView()
                    }
                }
                if showCustomLoadingView {
                    CustomLoadingView(showCustomLoadingView: $showCustomLoadingView)
                        .transition(.move(edge: .leading))
                }
            }
            .zIndex(2.0) // This zIndex will ensure that the loading view is on top of other views
            .environmentObject(model)
        }
    }
}
