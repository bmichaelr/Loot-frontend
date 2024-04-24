//
//  Page4.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page4: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Text("Game screen")
                        .font(.custom("Quasimodo", size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                Text(page4txt1)
                Image("lootPhoneExample")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                Text(page4txt2)
                    .padding(.horizontal)
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    Page4()
}
