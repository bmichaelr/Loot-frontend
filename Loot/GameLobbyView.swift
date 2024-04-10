//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var ready: Bool = true
    @State var readyTime: ReadyTimer = ReadyTimer()
    @State var readyTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        Text("\(viewModel.lobbyData.name)!")
                            .font(.custom("Quasimodo", size: 28))
                            .multilineTextAlignment(.center)
                            .padding()

                        Spacer()
                    }.padding()

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

                    Spacer()

                    VStack {
                        if viewModel.lobbyData.allReady == true {
                            HStack {
                                Spacer()

                                Text("Game Starting In .. \(readyTime.timeRemaining)")
                                    .font(.custom("Quasimodo", size: 20))
                                    .multilineTextAlignment(.center)
                                    .onReceive(readyTimer) {_ in
                                        if readyTime.timeRemaining > 0 {
                                            readyTime.timeRemaining -= 1
                                        } else {
                                            print("Start Game")
                                            viewModel.startGame()
                                        }
                                    }
                                Spacer()
                            }
                        }
                    }.onReceive(readyTimer) { _ in
                        if viewModel.lobbyData.allReady != true {
                            readyTime.reset()
                        }
                    }

                    Spacer()

                    CustomButton(text: ready ? "Ready" : "Unready",
                                 onClick: readyButtonClicked,
                                 buttonColor: ready ? Color.lootGreen : Color.red)
                    .padding(.top, 30)

                    Spacer()
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
                ToolbarItem(placement: .principal) {
                    Text("Lobby")
                        .font(.custom("Quasimodo", size: 14))
                        .foregroundStyle(Color.lootBeige)
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

    struct ReadyTimer {
        var minTime = 10
        var timeRemaining = 10

        mutating func reset() {
            self.timeRemaining = self.minTime
        }
    }
}

#Preview {
    GameLobbyView()
        .environmentObject(AppViewModel())
}
