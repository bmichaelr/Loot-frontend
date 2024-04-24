//
//  PlayerProfileView.swift
//  Loot
//
//  Created by Kenna Chase on 4/15/24.
//

import SwiftUI

struct ModifyProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var profileStore: ProfileStore
    @State private var imageNumber: Int = 1
    @State var name = ""
    @State var bgColor = Color.lootBeige

    @State private var profileImagePressed = false

    @Binding var displayModifyProfile: Bool

    var body: some View {
        var profile = profileStore.playerProfile
        NavigationStack {
            ZStack {
                Color.lootBeige.ignoresSafeArea(.all)
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(Color.lootBrown)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 2)
                            )

                        VStack {
                            Text("Player Profile")
                                .font(.custom("Quasimodo", size: 30))
                                .foregroundStyle(Color.lootBeige)
                                .multilineTextAlignment(.center)
                                .padding()

                            PlayerProfileView(name: name, imageNumber: imageNumber, bgColor: bgColor.toHexString())
                            .padding()
                            .frame(width: 300, height: 300, alignment: .center)
                            .onTapGesture {
                                profileImagePressed.toggle()
                            }

                            HStack {
                                Spacer()
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.lootBeige)
                                    .padding()
                                    .onTapGesture {
                                        if imageNumber - 1 > 0 {
                                            imageNumber -= 1
                                        } else {
                                            imageNumber = 8
                                        }
                                    }

                                Spacer()

                                ColorPicker("", selection: $bgColor, supportsOpacity: false) .labelsHidden()

                                Spacer()

                                Image(systemName: "arrow.right")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.lootBeige)
                                    .padding()
                                    .onTapGesture {
                                        if imageNumber + 1 <= 8 {
                                            imageNumber += 1
                                        } else {
                                            imageNumber = 1
                                        }
                                    }

                                Spacer()
                            }

                            CustomTextField(text: $name, prompt: "Your Name")
                                .multilineTextAlignment(.center)
                                .padding()

                            CustomButton(text: "Save Profile") {
                                print("Save Profile")
                                profile.name = name
                                profile.imageNum = imageNumber
                                profile.background = bgColor.toHexString()

                                if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
                                    UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
                                    UserDefaults.standard.synchronize()

                                }
                                Task {
                                    do {
                                        try await profileStore.save(profile: profile)
                                    } catch {
                                        fatalError(error.localizedDescription)
                                    }
                                }
                                displayModifyProfile = false
                            }.padding()

                        }
                    }
                    .padding([.leading, .trailing], 20)

                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackground()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("dragon")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }.padding()

            }
        }.onAppear(perform: {
            if UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
                // Load Existing Profile
                Task {
                    do {
                        try await profileStore.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                profile = profileStore.playerProfile
                imageNumber = profile.imageNum
                name = profile.name
                bgColor = Color(hex: profile.background)
            }
        })
    }
}
