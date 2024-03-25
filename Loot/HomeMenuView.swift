//
//  HomeMenuView.swift
//  Loot
//
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct HomeMenuView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var gameRoomKey: String = ""

    var body: some View {
        Spacer()
        // Display the game title.
        Text("Loot!")
            .font(.largeTitle)

        VStack {
            Spacer()

            Button {
                viewModel.createGame()
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
                    viewModel.joinGame(gameRoomKey)
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
        .onAppear(perform: self.viewModel.subscribeToMatchmakingChannels)
        .onDisappear(perform: self.viewModel.unsubscribeFromMatchmakingChannels)
    }
}

#Preview {
    HomeMenuView()
        .environmentObject(AppViewModel())
}
