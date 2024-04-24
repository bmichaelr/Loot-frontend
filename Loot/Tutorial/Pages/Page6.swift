//
//  Page6.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page6: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Text("Game screen: Indicators")
                        .font(.custom("Quasimodo", size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                Text(page6txt1)
                    .padding(.horizontal)
                HStack {
                    Image("lootSafeExample")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 175)
                    Image("lootOutExample")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 175)
                }
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    Page6()
}
