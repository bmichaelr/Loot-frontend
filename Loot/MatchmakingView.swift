//
//  MatchmakingView.swift
//  Loot
//
//  Created by Benjamin Michael on 3/26/24.
//

import SwiftUI

struct MatchmakingView: View {
    @EnvironmentObject var viewModel: AppViewModel

    @State private var createButtonPressed = false
    @State private var refreshedPressed = false

    var body: some View {

        let mainBoxWidth = 350

        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack {
                    NavigationBar()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.lootBrown)
                            .frame(width: CGFloat(mainBoxWidth), height: 500)

                        VStack {
                            HStack {
                                Spacer()
                                Text("Name")
                                Spacer()
                                Text("Players")
                                Spacer()
                                Text("Status")
                                Spacer()
                            }
                            .font(Font.custom("Quasimodo", size: 16).weight(.medium))
                            .foregroundColor(.lootBeige)
                            .padding()

                            ScrollView {
                                Spacer()
                                ForEach(viewModel.serverList, id: \.key) { server in
                                    Server(server: server)
                                        .onTapGesture {
                                            // This is where the connect to server function goes
                                            print("Server \(server.name) tapped, key: \(server.key)")
                                            viewModel.joinGame(server.key)
                                        }
                                }
                            }.frame(width: 350, height: 400)

                            // Refresh Button
                            Image(systemName: "arrow.clockwise")
                                .frame(width: CGFloat(mainBoxWidth - 50), alignment: .trailing)
                                .foregroundColor(.lootBeige)
                                .bold()
                                .onTapGesture {
                                    refreshedPressed.toggle()
                                    print("Refreshing server list...")
                                    viewModel.reloadServerList()
                            }
                        }

                    }.padding()

                    Spacer()

                    CustomButton(text: "Create Game", onClick: { createButtonPressed.toggle() })

                    Spacer()

                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackground()
                    
                }
            }
            .sheet(isPresented: $createButtonPressed) {
                CreateGameView()
                    .presentationDetents([.medium])
            }
        }
        .onAppear(perform: self.viewModel.subscribeToMatchmakingChannels)
        .onDisappear(perform: self.viewModel.unsubscribeFromMatchmakingChannels)
    }
}

struct Server: View {
    let server: ServerResponse
    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lootBeige)
                .frame(width: 320, height: 50)
            VStack {
                HStack {
                    Spacer()
                    Text(server.name).font(Font.custom("Quasimodo", size: 14).weight(.medium))
                    Spacer()
                    Text(" \(server.numberOfPlayers)/\(server.maximumPlayers)")
                        .font(Font.custom("Quasimodo", size: 14).weight(.medium))
                    Spacer()
                    Image(systemName: "circle.fill").foregroundColor(server.isJoinable() ? .lootGreen : .lootRed)
                    Spacer()
                }.padding().containerRelativeFrame(.horizontal).font(Font.custom("Quasimodo", size: 16).weight(.medium))

            }
        }

    }
}

 extension View {
    func navigationBarBackground(_ background: Color = Color.lootBrown) -> some View {
        return self
            .modifier(ColoredNavigationBar(background: background))
    }
 }

struct ColoredNavigationBar: ViewModifier {
    var background: Color
    func body(content: Content) -> some View {
        content
            .toolbarBackground(
                background,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    MatchmakingView()
        .environmentObject(AppViewModel())
}
