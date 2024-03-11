//
//  HomeMenuView.swift
//  Loot
//
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct HomeMenuView: View {
    @ObservedObject var displayViewController = DisplayViewController.sharedViewDisplayController

    @State private var gameRoomKey: String = ""

    var body: some View {
        Spacer()
        // Display the game title.
        Text("Loot!")
            .font(.largeTitle)

        VStack {
            Spacer()

            Button {
                // Create Game Logic
                gameRoomKey = createGame()
            } label: {
                Text("Create Game")
                    .foregroundColor(.black)
                    .font(.title2)
                    .bold()
            }
            .background(
                Capsule(style: .continuous)
                .fill(.gray)
                .frame(width: 250, height: 50)
            )

            Spacer()

            VStack {
                TextField(
                    "Enter Game Room Key ",
                    text: $gameRoomKey
                ).bold()
                    .padding(.vertical, 30)
                    .multilineTextAlignment(.center)
                    .disableAutocorrection(true).onSubmit {
                        print("Authenticating…")
                    }

                Button("Join Game") {
                    // Join Game Logic
                    joinGame(gameKey: gameRoomKey)

                } .foregroundColor(.black)
                    .font(.title2)
                    .bold()
                    .background(
                        Capsule(style: .continuous)
                        .fill(.gray)
                        .frame(width: 250, height: 50)
                    )
            }

          Spacer()

        }
    }

    func joinGame(gameKey: String) {
        print("\nAuthenticating ... ")
        // Validate Game Logic
        print("Joining game ...." + gameKey)
        displayViewController.changeView(view: .gameLobbyView)
    }

    func createGame() -> String {
        print("\nCreating game .....")
        displayViewController.changeView(view: .tus)
        return "FAKE_GAME_CODE"
    }
}

#Preview {
    HomeMenuView()
}
