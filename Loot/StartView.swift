//  ContentView.swift
//  Loot
//
//  Created by Benjamin Michael on 2/25/24.
//
//  Additions to StartingView - IR on 3/10/24.

import SwiftUI

struct StartView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @FocusState private var nameFieldFocused: Bool
    private func hideKeyboard() {
            nameFieldFocused = false
        }
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(.keyboard)
                .onTapGesture {
                    hideKeyboard()
                }
            VStack {
                Text("Welcome to Loot!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                Spacer()
                Image("lootlogotemp")
                    .resizable()
                    .scaledToFit()
                    .padding()
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.clear)
                                .border(.black, width: 2)
                                .frame(width: 120, height: 30)
                            Text("Create Name:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                                .foregroundColor(.black)
                                .font(.headline)
                                .padding(.leading, 5)
                        }
                        TextField("Enter your name here...", text: $viewModel.playerName)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled(true)
                            .focused($nameFieldFocused)
                            .padding()
                    }
                    Button {
                        viewModel.connectToSocket()
                    } label: {
                        if viewModel.connecting {
                            ProgressView()
                        } else {
                            Text("Connect")
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(25)
                }
                .padding()
            }
        }.onTapGesture {
            hideKeyboard()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(AppViewModel())
    }
}
