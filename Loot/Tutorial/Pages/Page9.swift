//
//  Page9.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page9: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Text("Game screen: card info")
                        .font(.custom("Quasimodo", size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                Image("lootCardViewExample")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text(page9txt1)
                    .padding(.horizontal)
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    Page9()
}
