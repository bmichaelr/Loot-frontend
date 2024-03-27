//
//  testHomeMenuView.swift
//  Loot
//
//  Created by Benjamin Michael on 3/26/24.
//

import SwiftUI

struct MatchmakingView: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack {
                    List {
                        ForEach(viewModel.serverList, id: \.key) { server in
                            Server(server: server)
                                .onTapGesture {
                                    // This is where the connect to server function goes
                                    print("Server \(server.name) tapped, key: \(server.key)")
                                }
                        }
                    }
                }
            }
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
        .onAppear(perform: self.viewModel.subscribeToMatchmakingChannels)
        .onDisappear(perform: self.viewModel.unsubscribeFromMatchmakingChannels)
    }
}

struct Server: View {
    let server: ServerResponse
    var body: some View {
        HStack {
            Text(server.name)
            Spacer()
            Text("Players: \(server.numberOfPlayers)/\(server.maximumPlayers)")
            Spacer()
            Text(server.status)
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
