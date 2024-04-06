//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var ready: Bool = true
    var body: some View {
        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    Text("Room Name - \(viewModel.lobbyData.name)")
                        .font(.custom("Quasimodo", size: 28))
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 280)
                            .background(Color.lootBrown)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                            )
                        VStack(alignment: .center) {
                            HStack {
                                Text("Player")
                                    .font(.custom("Quasimodo", size: 16))
                                    .foregroundStyle(Color.lootBeige)
                                Spacer()
                                Text("Ready")
                                    .font(.custom("Quasimodo", size: 16))
                                    .foregroundStyle(Color.lootBeige)
                            }
                            .padding([.leading, .trailing], 30)
                            .padding(.top, 20)
                            let numberOfPlayers = viewModel.lobbyData.players.count
                            ForEach(0..<viewModel.lobbyData.maxPlayers, id: \.self) { num in
                                if num < numberOfPlayers {
                                    let player = viewModel.lobbyData.players[num]
                                    LobbyPlayerView(name: player.name, ready: player.ready)
                                        .padding([.leading, .trailing], 15)
                                } else {
                                    LobbyPlayerView()
                                        .padding([.leading, .trailing], 15)
                                }
                            }
                        }
                    }
                    CustomButton(text: ready ? "Ready" : "Unready",
                                 onClick: readyButtonClicked,
                                 buttonColor: ready ? Color.lootGreen : Color.red)
                    .padding(.top, 30)
                }
                .padding([.leading, .trailing], 20)
            }
            .onAppear(perform: self.viewModel.subscribeToLobbyChannels)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackground()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.leaveGame(viewModel.lobbyData.roomKey)
                    } label: {
                        Text("Leave")
                            .font(.custom("Quasimodo", size: 14))
                            .foregroundStyle(Color.lootBeige)
                    }
                }
            }
        }
    }
    func readyButtonClicked() {
        viewModel.changeReadyStatus(ready)
        withAnimation(.spring) {
            ready.toggle()
        }
    }
}

#Preview {
    GameLobbyView()
        .environmentObject(AppViewModel())
}
