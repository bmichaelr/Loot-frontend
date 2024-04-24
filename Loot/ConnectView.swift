//
//  test_StartView.swift
//  Loot
//
//  Created by Michael, Ben on 3/26/24.
//

import SwiftUI

struct ConnectView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var profileStore: ProfileStore
    @FocusState private var nameFieldFocused: Bool
    @State private var buttonPressed = false
    @State private var presentProfile = false

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
                        Text("Loot!")
                            .font(Font.custom("Quasimodo", size: 48).weight(.medium))
                            .foregroundColor(.black)
                            .offset(y: -35)
                        Text("based on munchkin:")
                            .font(Font.custom("Quasimodo", size: 24).weight(.medium))
                            .foregroundColor(.black)
                            .offset(y: 15)
                        Text("loot letter")
                            .font(Font.custom("Quasimodo", size: 30).weight(.medium))
                            .foregroundColor(.black)
                            .offset(y: 40)
                    }
                    .padding()
                    Image("dragon")
                        .resizable()
                        .scaledToFit()
                        .offset(y: -60)
                        .onTapGesture {
                            viewModel.viewController.changeView(view: .gameView)
                        }
                }
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 200)
                            .background(Color.lootBeige)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                            )
                        HStack {
                            if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
                                Spacer()
                                Text("Create Profile")
                                    .font(.custom("Quasimodo", size: 20))
                                Spacer()
                            } else {
                                // Display Previous Existing Profile
                                PlayerProfileView(
                                    name: profileStore.playerProfile.name,
                                    imageNumber: profileStore.playerProfile.imageNum,
                                    bgColor: profileStore.playerProfile.background)
                                .frame(width: 200, height: 200)
                                Spacer()
                                Text(profileStore.playerProfile.name)
                                    .font(.custom("Quasimodo", size: 18))
                            }

                        }
                        .padding([.leading, .trailing], 20)
                    }.onTapGesture {
                        presentProfile.toggle()
                    }
                    CustomButton(text: "Connect", onClick: viewModel.connectToSocket)
                }

                .offset(y: -30)
                .padding([.leading, .trailing], 20)
                .onAppear(perform: {
                    Task {
                        do {
                            try await profileStore.load()
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                })
                .sheet(isPresented: $presentProfile) {
                    NavigationView {
                        ModifyProfileView()
                            .presentationDetents([.medium])
                    }
                }
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
