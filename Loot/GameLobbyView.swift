//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {
    @EnvironmentObject var viewModel: AppViewModel

    let peopleTest: [String] = ["Name1", "Name2", "Name3", "Name4"]

    @State var isReady: Bool = false
    // Kenna -
    // Access the list of players in the lobby by doing "viewModel.lobbyData.players"
    // The room key is found at "viewModel.lobbyData.roomKey"
    // Each player has a set of information, like player.name, player.ready, etc.
    // The struct used for players can be found in the LobbyResponse file, it is called GamePlayer
    //
    // One last thing -- for the ready up functionality, call viewModel.changeReadyStatus and pass some boolean as an argument, which can
    // be the isReady bool you already have like => viewModel.changeReadyStatus(isReady.toggle())
    //

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Game Room Key: XXX-XXX")
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()
                Spacer()
           }
            Section {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(peopleTest, id: \.self) { player in
                        HStack {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                                .padding()
                            Spacer()
                            Text(player)
                            Spacer()
                            Image(systemName: "xmark")
                                .foregroundColor(Color.red)
                            // TODO: Setup symbol change "checkmark"
                            Spacer()
                        }.overlay(
                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 350, height: 50)
                        )
                        .padding(20)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            // Ready Up Button Logic
                            isReady.toggle()
                            // displayViewController.changeView(view: .gameView)
                        } label: {
                            Text("Ready")
                                .foregroundColor(.black)
                                .font(.title2)
                                .bold()
                        }
                        .background(
                            Capsule(style: .continuous)
                                .fill(isReady ? .gray : .green)
                                .frame(width: 250, height: 50)
                        )
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GameLobbyView()
        .environmentObject(AppViewModel())
}
