//
//  test_StartView.swift
//  Loot
//
//  Created by Michael, Ben on 3/26/24.
//

import SwiftUI

struct ConnectView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @FocusState private var nameFieldFocused: Bool
    @State private var buttonPressed = false
    private func hideKeyboard() {
            nameFieldFocused = false
        }
    var body: some View {
        ZStack {
            Color.lootBrown.ignoresSafeArea(.all)
            VStack(alignment: .center) {
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 180)
                            .background(Color.lootBeige)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .inset(by: 0.75)
                                    .stroke(.black, lineWidth: 2)
                            )
                        Text("Munchkin")
                            .font(Font.custom("Quasimodo", size: 48).weight(.medium))
                            .foregroundColor(.black)
                            .offset(y: -35)
                        Text("Loot")
                            .font(Font.custom("Quasimodo", size: 42).weight(.medium))
                            .foregroundColor(.black)
                            .offset(y: 20)
                        Text("LETTER!")
                            .font(Font.custom("Quasimodo", size: 42).weight(.medium))
                            .foregroundColor(.black)
                            .offset(y: 55)
                    }
                    .padding()
                    Image("dragon")
                        .resizable()
                        .scaledToFit()
                        .offset(y: -50)
                        .onTapGesture {
                            viewModel.viewController.changeView(view: .gameView)
                        }
                }
                VStack {
                    CustomTextField(text: $viewModel.playerName, isFocused: _nameFieldFocused, prompt: "Enter your name here...")
                    CustomButton(text: "Connect", onClick: viewModel.connectToSocket)
                }
                .offset(y: -30)
                .padding([.leading, .trailing], 20)
            }
            .padding(EdgeInsets(top: 39, leading: 10, bottom: 39, trailing: 10))
            .cornerRadius(10)
        }
        .onTapGesture(perform: hideKeyboard)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ConnectView()
        .environmentObject(AppViewModel())
}
