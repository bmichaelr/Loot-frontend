//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {
    @ObservedObject var displayViewController = DisplayViewController.sharedViewDisplayController

    var body: some View {

        HStack {
            Spacer()

            Text("Game Room Key: XXX-XXX")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .bold()

            Spacer()
       }

        VStack {
            Button {
                displayViewController.changeView(view: .gameView)
            } label: {
                Text("Temp Button: Start Game")
                    .foregroundColor(.black)
                    .font(.title2)
                    .bold()
            }
            .background(
                Capsule(style: .continuous)
                .fill(.gray)
                .frame(width: 250, height: 50)
            )

        }.padding()

        Spacer()
    }
}

#Preview {
    GameLobbyView()
}
