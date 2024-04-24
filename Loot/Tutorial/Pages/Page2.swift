//
//  Page2.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page2: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Game Overview")
                    .font(.custom("Quasimodo", size: 28))
                    .foregroundStyle(Color.black)
                    .padding(.leading)
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                Section {
                    Text("- " + page2txt1)
                        .padding(.bottom, 5)
                    Text("- " + page2txt2)
                        .padding(.bottom, 5)
                    Text("- " + page2txt3)
                        .padding(.bottom, 5)
                    Text("- " + page2txt4)
                } header: {
                    Text("Setup")
                        .font(.custom("Quasimodo", size: 24))
                        .padding(.top)
                }
                .padding(.horizontal, 35)
                Section {
                    Text("- " + page2txt5)
                        .padding(.bottom, 5)
                    Text("- " + page2txt6)
                        .padding(.bottom, 5)
                    Text("- " + page2txt7)
                        .padding(.bottom, 5)
                    Text("- " + page2txt8)
                } header: {
                    Text("Sequence of play")
                        .font(.custom("Quasimodo", size: 24))
                        .padding(.top)
                }
                .padding(.horizontal, 35)
                Spacer()
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    Page2()
}
