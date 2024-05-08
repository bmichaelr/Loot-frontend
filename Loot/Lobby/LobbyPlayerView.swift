//
//  LobbyPlayerView.swift
//  Loot
//
//  Created by Michael, Ben on 4/3/24.
//

import SwiftUI

struct LobbyPlayerView: View {
    var name: String = "Waiting"
    var imageNum: Int = 1
    var background: String = "#000000"
    var ready: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.lootBeige)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 2)
                )
            HStack {
                PlayerProfileView(name: name, imageNumber: imageNum, bgColor: background)
                    .padding()
                Spacer()
                Text(name)
                    .font(.custom("Quasimodo", size: 18))
                Spacer()
                Image(systemName: ready ? "checkmark" : "xmark")
                    .foregroundStyle(ready ? Color.green : Color.red)
            }
            .padding([.leading, .trailing], 20)

        }
    }
}

#Preview {
    LobbyPlayerView()
}
