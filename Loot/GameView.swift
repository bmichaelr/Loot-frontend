//
//  GameView.swift
//  Loot
//
//  Created by Kenna Chase on 3/11/24.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        Text("Game View")
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Loot!")
        }
        .padding()
    }
}

#Preview {
    GameView()
}
