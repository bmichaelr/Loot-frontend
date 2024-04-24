//
//  Page7.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page7: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Text("Game screen: rulebook")
                        .font(.custom("Quasimodo", size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                Image("lootPhoneRulebookHighlightedExample")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text(page7txt1)
                    .padding(.horizontal)
                Divider()
                    .overlay(.black)
                    .padding(.horizontal)
                HStack {
                    VStack {
                        Text("Front side view")
                        Image("lootRuleFrontExample")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175)
                    }
                    VStack {
                        Text("Back side view")
                        Image("lootRuleBackExample")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175)
                    }
                }
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    Page7()
}
