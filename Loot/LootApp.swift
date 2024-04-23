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
    @State private var transitioningFromConnectView: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch displayViewController.currentView {
                case .gameLobbyView:
                    GameLobbyView()
                case .homeMenuView:
                    TabView {
                        MatchmakingView()
                            .tabItem {
                                Label("Play", systemImage: "play.fill")
                            }
                        LeaderboardView(model:
                                            LeaderboardViewModel(
                                                id: model.clientUUID,
                                                name: model.playerName,
                                                stomp: model.stompClient))
                            .tabItem {
                                Label("Leaderboard", systemImage: "trophy.fill")
                            }
                    }
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
                        .onAppear {
                            transitioningFromConnectView = true
                        }
                }
                if showCustomLoadingView {
                    CustomLoadingView(showCustomLoadingView: $showCustomLoadingView)
                        .transition(.move(edge: .leading))
                }
            }
            .showCustomAlert(alert: $model.alert)
            .zIndex(2.0) // This zIndex will ensure that the loading view is on top of other views
            .environmentObject(model)
        }
    }
}
