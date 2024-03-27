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
                }
                VStack {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 40)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                            )
                        TextField("enter your name here...", text: $viewModel.playerName)
                            .font(Font.custom("Quasimodo", size: 14).weight(.medium))
                            .foregroundColor(.black)
                            .autocorrectionDisabled(true)
                            .focused($nameFieldFocused)
                            .padding(.leading, 20)
                    }
                    ZStack(alignment: .center) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 50)
                            .background(Color.lootGreen)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                            )
                            .shadow(
                                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                            )
                            .scaleEffect(buttonPressed ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.1))
                        Text("Connect")
                            .font(Font.custom("Quasimodo", size: 16).weight(.medium))
                            .foregroundColor(.black)
                    }
                    .onTapGesture {
                        withAnimation {
                            buttonPressed.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                buttonPressed.toggle()
                                viewModel.connectToSocket()
                            }
                        }
                    }
                }
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
