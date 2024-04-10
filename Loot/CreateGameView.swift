//
//  CreateGameView.swift
//  Loot
//

import SwiftUI

struct CreateGameView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var roomName: String = ""
    @State private var numberOfPlayers: Int = 4
    @State private var numberOfRounds: Int = 3
    var buttonEnabled: Bool {
        roomName.count > 0
    }
    var body: some View {
        ZStack {
            Color.lootBrown.ignoresSafeArea(.all)
            VStack(alignment: .center) {
                Text("Create Game")
                    .font(.custom("Quasimodo", size: 18))
                    .foregroundStyle(Color.lootBeige)
                    .padding([.top, .bottom], 15)
                CustomTextField(text: $roomName, prompt: "Enter the room name...")
                HStack {
                    Text("Number of rounds")
                        .font(.custom("Quasimodo", size: 14))
                        .padding(.leading, 15)
                    Spacer()
                    Picker("Round", selection: $numberOfRounds) {
                        ForEach(1...10, id: \.self) { num in
                            Text(String(num))
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.trailing, 15)
                    .pickerStyle(.menu)
                }
                .padding([.top, .bottom], 5)
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.white).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 2)
                ))
                VStack {
                    Text("Number of players:")
                        .font(.custom("Quasimodo", size: 14))
                        .padding([.top, .bottom], 10)
                    Picker("Players", selection: $numberOfPlayers) {
                        ForEach(2...4, id: \.self) { num in
                            Text(String(num))
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.white).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 2)
                ))
                CustomButton(text: "Create",
                             onClick: { viewModel.createGame(roomName, numberOfPlayers, numberOfRounds) },
                             enabled: buttonEnabled)
                Spacer()
            }
            .padding()
        }
    }
}
#Preview {
    CreateGameView()
        .environmentObject(AppViewModel())
}
