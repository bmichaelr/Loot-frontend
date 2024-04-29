//
//  PlayerProfileView.swift
//  Loot
//
//  Created by Kenna Chase on 4/15/24.
//

import SwiftUI

struct PlayerProfileView: View {
    var name: String
    var imageNumber: Int
    var bgColor: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: bgColor))
                .stroke(.black, lineWidth: 5)
            Image("loot_" + String(imageNumber))
                .resizable()
                .padding()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
        }
    }
}
#Preview {
    PlayerProfileView(name: "Test", imageNumber: 1, bgColor: "#000000")
}
