//  ContentView.swift
//  Loot
//
//  Created by Benjamin Michael on 2/25/24.
//
//  Additions to StartingView - IR on 3/10/24.

import SwiftUI

struct StartView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
                ZStack(alignment: .top) {
                    Text("Welcome to Loot!")
                        // .padding()
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(8)
                        .padding()
                    // temp logo for top center of load in/create name page
                    Image("lootlogotemp")
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                VStack(alignment: .center) {
                    // HStack horizontal allows for us to be able to move fields 
                    // from .leading (left side) & .trailing (right side)
                    HStack {
                        Text(" Create Name:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    // name will become unique identifier in later development. UID, Username, etc.
                    TextField("Enter your name here...", text: $viewModel.playerName)
                        // .padding()
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled(true)
                    Button {
                        viewModel.connectToSocket()
                    } label: {
                        if viewModel.connecting {
                            ProgressView()
                        } else {
                            Text("Connect")
                        }
                    }
                        .buttonStyle(.bordered)
                        .frame(width: 100)
                        // .frame(width: 225)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding()
                    Text("WIP by:")
                        .font(.headline)
                    HStack {
                        Text("Ben")
                        Text("Josh")
                        Text("Kenna")
                        Text("Ian")
                    }

                }
                .padding()
            }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(AppViewModel())
    }
}
