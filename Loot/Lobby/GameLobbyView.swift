//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var profileStore: ProfileStore
    @State private var ready: Bool = true
    @State private var tutorialButtonPressed = false
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

                    Spacer()

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
                                    LobbyPlayerView(name: player.name, imageNum: player.profilePicture, background: player.profileColor, ready: player.ready)
                                        .padding([.leading, .trailing], 15)
                                        .frame(height: 100)
                                }
                            }
                        }.padding()
                            .background(content: {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    // .frame(height: 280)
                                    .background(Color.lootBrown)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.black, lineWidth: 2)
                                    )})

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
            .onAppear(perform: {
                self.viewModel.subscribeToLobbyChannels()
                self.viewModel.playerName = profileStore.playerProfile.name
                self.viewModel.playerPhoto = profileStore.playerProfile.imageNum
                self.viewModel.playerBackground = profileStore.playerProfile.background
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackground()
            .toolbar {
                HStack {
                                            Button {
                                        viewModel.leaveGame(viewModel.lobbyData.roomKey)
                                    } label: {
                                        Text("Leave")
                                            .font(.custom("Quasimodo", size: 14))
                                            .foregroundStyle(Color.lootBeige)
                                    }
                                                .scaledToFit()
                                                .frame(alignment: .leading)
                                            Spacer()
                                            Image("dragon")
                                                .resizable()
                                                .scaledToFit().frame(alignment: .center)
                                            Spacer()
                                            Button(action: {
                                                    tutorialButtonPressed.toggle()
                                                }) {
                                            Image(systemName: "questionmark.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.lootBeige)
                                            }.frame(alignment: .leading)
                                        }

            }.sheet(isPresented: $tutorialButtonPressed) {
                NavigationView {
                    TutorialView($tutorialButtonPressed)
                        .presentationDetents([.medium])
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
