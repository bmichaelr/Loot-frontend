//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State var isReadyButton: Bool = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Game Room Key: " + viewModel.lobbyData.roomKey)
                    .font(.title)
                    .bold()
                Spacer()
           }
            Section {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.lobbyData.players, id: \.id) { player in
                        HStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                                .padding()
                            Spacer()
                            Text(player.name)
                            Spacer()

                            if player.ready {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.green)
                            } else {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.red)
                            }
                            Spacer()
                        }.overlay(
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 350, height: 50)
                        )
                        .padding(20)
                    }
                    Spacer()
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            // Ready Up Button Logic
                            isReadyButton.toggle()
                            print("ReadyButton Status: " + String(isReadyButton))
                            viewModel.changeReadyStatus(isReadyButton)
                        } label: {
                            Text("Ready")
                                .foregroundColor(.black)
                                .font(.title2)
                                .bold()
                        }
                        .background(
                            Capsule(style: .continuous)
                                .fill(isReadyButton ? .gray : .green)
                                .frame(width: 250, height: 50)
                        )
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            // Start Game Transition Logic for testing
                            viewModel.viewController.changeView(view: .gameView)
                        } label: {
                            Text("Start Game")
                                .foregroundColor(.black)
                                .font(.title2)
                                .bold()
                        }
                        .background(
                            Capsule(style: .continuous)
                                .fill(.orange)
                                .frame(width: 250, height: 50)
                        )
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .onAppear(perform: self.viewModel.subscribeToLobbyChannels)
        .onDisappear(perform: self.viewModel.unsubscribeFromLobbyChannels)
    }

}

#Preview {
    GameLobbyView()
        .environmentObject(AppViewModel())
}
