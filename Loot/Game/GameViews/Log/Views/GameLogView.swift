//
//  GameLogView.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import SwiftUI

struct GameLogView: View {
    @ObservedObject var gameLog: GameLog
    @State private var showing = false
    @State private var offset: CGFloat = UIScreen.main.bounds.width * 0.80
    let width = UIScreen.main.bounds.width * 0.80
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Game Log:")
                    .multilineTextAlignment(.center)
                    .font(.custom("Windlass", size: 26))
                    .foregroundStyle(Color.lootBeige)
                    .padding(.horizontal)
                    .padding(.top, 10)
                Divider()
                    .frame(height: 2)
                    .overlay(.black.opacity(0.8))
                    .padding(.horizontal, 25)
                List {
                    ForEach(gameLog.roundLogs) { log in
                        RoundLogList(round: log)
                    }
                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
            }
            .background(
                Rectangle()
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft]))
                    .ignoresSafeArea(.all)
                    .foregroundStyle(Color.lootBrown)
            )
            .shadow(radius: 15)
            .frame(width: width)
            .overlay(alignment: .leading) {
                SideMenuTab(open: $showing)
                    .shadow(radius: 10)
                    .offset(x: -20)
                    .onTapGesture {
                        withAnimation {
                            showing.toggle()
                            if offset == 0.0 {
                                offset = width
                            } else {
                                offset = 0.0
                            }
                        }
                    }
            }
        }
        .offset(x: offset)
    }
}

struct ListExample_Previews: PreviewProvider {
    struct Wrapper: View {
        @StateObject var gameLog = GameLog()
        var body: some View {
            GameLogView(gameLog: gameLog)
        }
    }
    static var previews: some View {
        GameLogView(gameLog: GameLog())
    }
}
