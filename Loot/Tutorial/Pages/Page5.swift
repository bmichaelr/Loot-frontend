//
//  Page5.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page5: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Text("Game screen: Overview")
                        .font(.custom("Quasimodo", size: 28))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                    .overlay(.gray)
                    .padding(.horizontal)
                Text(page5txt1)
                    .padding(.horizontal)
                Image("lootPhoneExampleOutlines")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                VStack {
                    HStack {
                        Text("Key")
                            .padding(.horizontal)
                            .frame(width: 75)
                        Divider()
                            .overlay(.black)
                        Text("Meaning")
                            .padding(.leading)
                        Spacer()
                    }
                    Divider()
                        .overlay(.black)
                        .padding(.horizontal)
                    HStack(alignment: .top) {
                        Image(systemName: "rectangle")
                            .foregroundStyle(.yellow)
                            .font(.largeTitle)
                            .frame(width: 75)
                        Divider()
                            .overlay(.black)
                        Spacer()
                        Text(page5txt3)
                        Spacer()
                    }
                    Divider()
                        .overlay(.black)
                        .padding(.horizontal)
                    HStack(alignment: .top) {
                        Image(systemName: "circle")
                            .foregroundStyle(.blue)
                            .font(.largeTitle)
                            .frame(width: 75)
                        Divider()
                            .overlay(.black)
                        Spacer()
                        Text(page5txt4)
                        Spacer()
                    }
                    Divider()
                        .overlay(.black)
                        .padding(.horizontal)
                    HStack(alignment: .top) {
                        Image(systemName: "circle")
                            .foregroundStyle(.green)
                            .font(.largeTitle)
                            .frame(width: 75)
                        Divider()
                            .overlay(.black)
                        Spacer()
                        Text(page5txt5)
                        Spacer()
                    }
                    Divider()
                        .overlay(.black)
                        .padding(.horizontal)
                    HStack(alignment: .top) {
                        Image(systemName: "circle")
                            .foregroundStyle(.red)
                            .font(.largeTitle)
                            .frame(width: 75)
                        Divider()
                            .overlay(.black)
                        Spacer()
                        Text(page5txt6)
                        Spacer()
                    }
                }
                .padding(.top)
            }
            .padding(.top)
            .font(.custom("CaslonAntique", size: 22))
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    Page5()
}
