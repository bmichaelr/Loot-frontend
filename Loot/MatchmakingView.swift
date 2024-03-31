//
//  testHomeMenuView.swift
//  Loot
//
//  Created by Benjamin Michael on 3/26/24.
//

import SwiftUI

struct MatchmakingView: View {
    @EnvironmentObject var viewModel: AppViewModel
    var testServer1: ServerResponse = ServerResponse(name: "Server 1", key: "0", maximumPlayers: 4, numberOfPlayers: 2, status: "Available")
    var testServer2: ServerResponse = ServerResponse(name: "Server 2", key: "4", maximumPlayers: 4, numberOfPlayers: 1, status: "In Game")
    var testServer3: ServerResponse = ServerResponse(name: "Server 3", key: "2", maximumPlayers: 4, numberOfPlayers: 2, status: "Available")
    var testServer4: ServerResponse = ServerResponse(name: "Server 4", key: "3", maximumPlayers: 4, numberOfPlayers: 4, status: "In Game")

    @State private var createButtonPressed = false

    var body: some View {
        let testServerList: [ServerResponse] = [testServer1, testServer2, testServer3, testServer4]

        let mainBoxWidth = 350
        let innerBoxWidth = 320

        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.lootBrown)
                            .frame(width: CGFloat(mainBoxWidth), height: 500)

                        VStack {
                            HStack {
                                Spacer()
                                Text("Name").font(Font.custom("Quasimodo", size: 16).weight(.medium)).foregroundColor(.lootBeige)
                                Spacer()
                                Text("Players").font(Font.custom("Quasimodo", size: 16).weight(.medium)).foregroundColor(.lootBeige)
                                Spacer()
                                Text("Status").font(Font.custom("Quasimodo", size: 16).weight(.medium)).foregroundColor(.lootBeige)
                                Spacer()
                            }.padding()

                            ScrollView {
                                Spacer()
                                ForEach(testServerList, id: \.key) { server in

                                    Server(server: server)
                                        .onTapGesture {
                                            // This is where the connect to server function goes
                                            print("Server \(server.name) tapped, key: \(server.key)")
                                        }
                                }
                            }.frame(width: 350, height: 400)

                            HStack {
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Spacer()
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.lootBeige)
                                    .bold()
                                    .onTapGesture {
                                    print("Refreshing server list...")
                                }
                                Spacer()
                            }

                        }

                    }.padding()

                    Spacer()

                    // CreateGameButton
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: CGFloat(mainBoxWidth), height: 50)
                            .background(Color.lootGreen)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                            )
                            .shadow(
                                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                            )
                            .scaleEffect(createButtonPressed ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.1))
                        Text("Create Game")
                            .font(Font.custom("Quasimodo", size: 18).weight(.heavy))
                            .foregroundColor(.black)
                    }.onTapGesture {
                        withAnimation {
                            createButtonPressed.toggle()
                        }
                    }
                    // Create Game Button End

                    Spacer()

                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackground()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("dragon")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
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
