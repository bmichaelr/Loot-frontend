//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {
    @ObservedObject var displayViewController = DisplayViewController.sharedViewDisplayController

    let peopleTest: [String] = ["Name1", "Name2", "Name3", "Name4"]

    var body: some View {
        VStack {

        Spacer()

        HStack {
            Spacer()

            Text("Game Room Key: XXX-XXX")
                    .font(.title)
                    .foregroundColor(.black)
                    .bold()

            Spacer()
       }
        // Spacer()

            Section {
                            VStack(alignment: .leading, spacing: 0) {
                                // ForEach(titles[key]!, id: \.self) { title in
                                ForEach(peopleTest, id: \.self) { player in

                                    HStack {

                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .frame(width: 32.0, height: 32.0)
                                            .padding()

                                        Spacer()
                                        Text(player)
                                        Spacer()
                                        Image(systemName: "xmark")
                                            .foregroundColor(Color.red)
                                        // Setup symbol change "checkmark"
                                        Spacer()
                                    }.overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .circular)
                                            .stroke(Color.black, lineWidth: 1)
                                            .frame(width: 350, height: 50)
                                            // .border(Color.black, width: 3)
                                    )// HSTACK
                                    .padding(20)
                                }//: LOOP

                                Spacer()
                                HStack {
                                    Spacer()
                                    Button {
                                        // Ready Up Button Logic
                                    } label: {
                                        Text("Ready")
                                            .foregroundColor(.black)
                                            .font(.title2)
                                            .bold()
                                    }
                                    .background(
                                        Capsule(style: .continuous)
                                        .fill(.gray)
                                        .frame(width: 250, height: 50)
                                    )
                                    Spacer()
                                }

                                // TODO: Have color change based on ready up status...

                            }//: VSTACK
                        }//: SECTION
        }
    }
}

#Preview {
    GameLobbyView()
}
