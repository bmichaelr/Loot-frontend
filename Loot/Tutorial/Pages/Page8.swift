//
//  Page8.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page8: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Text("Game screen: event log")
                        .font(.custom("Quasimodo", size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                Image("lootPhoneLogHighlightedExample")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text(page8txt1)
                    .padding(.horizontal)
                Divider()
                    .overlay(.black)
                    .padding(.horizontal)
                Image("lootLogExample")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                Text(page8txt2)
                    .padding(.horizontal)
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
        .scrollIndicators(.visible)
    }
}

#Preview {
    Page8()
}
