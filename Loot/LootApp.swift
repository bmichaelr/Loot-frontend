//
//  LootApp.swift
//  Loot
//
//  Created by Benjamin Michael on 2/25/24.
//

import SwiftUI

@main
struct LootApp: App {
    @ObservedObject var displayViewController = DisplayViewController.sharedViewDisplayController

    var body: some Scene {
        WindowGroup {
            switch displayViewController.currentView {
            case .gameLobbyView:
                GameLobbyView()
            case .homeMenuView:
                HomeMenuView()
            case .gameView:
                GameView()
            case .startNewGameView:
                HomeMenuView()
            }
        }
    }
}
