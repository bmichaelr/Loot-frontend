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
    @State private var tutorialButtonPressed = false

    @State private var refreshOpacity: CGFloat = 1.0
    var body: some View {
        let mainBoxWidth = 350
        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack {
                    Text("Available Games")
                        .font(Font.custom("Quasimodo", size: 30))
                        .foregroundStyle(Color.black)
                        .padding(.top, 30)
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
                            Divider()
                                .frame(height: 1)
                                .background(Color.black)
                                .padding([.leading, .trailing], 25)
                            ScrollView {
                                Spacer()
                                ForEach(viewModel.serverList, id: \.key) { server in
                                    Server(server: server)
                                        .onTapGesture {
                                            viewModel.joinGame(server.key, roomName: server.name)
                                        }
                                }
                            }
                            .frame(width: 350, height: 390)
                            Image(systemName: "arrow.clockwise")
                                .opacity(refreshOpacity)
                                .frame(width: CGFloat(mainBoxWidth - 50), alignment: .trailing)
                                .foregroundColor(.lootBeige)
                                .bold()
                                .onTapGesture {
                                    withAnimation {
                                        refreshOpacity = 0.75
                                    } completion: {
                                        viewModel.reloadServerList()
                                        withAnimation {
                                            refreshOpacity = 1.0
                                        }
                                    }
                            }
                        }

                    }
                    .padding()
                    CustomButton(text: "Create Game", onClick: { createButtonPressed.toggle() })
                        .padding([.leading, .trailing], 25)
                    Spacer()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackground()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("dragon")
                                .resizable()
                                .scaledToFit()
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                                                Button(action: {
                                                    tutorialButtonPressed.toggle()
                                                }) {
                                                    Image(systemName: "questionmark.circle.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(Color.lootBeige)
                                                }
                        }
                    }.sheet(isPresented: $tutorialButtonPressed) {
                        NavigationView {
                            TutorialView()
                                .presentationDetents([.medium])
                        }
                    }
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
