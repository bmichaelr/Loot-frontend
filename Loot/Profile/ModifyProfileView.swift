//
//  PlayerProfileView.swift
//  Loot
//
//  Created by Kenna Chase on 4/15/24.
//

import SwiftUI

struct ModifyProfileView: View {
    @State var name: String = ""
    private var imageName: String = "loot_"
    @State private var imageNumber: Int = 1
    @State private var bgColor = Color.lootBeige
    @State private var bgColorHex: String = "#000000" // Needs to be from saved profile...
    @State private var profileImagePressed = false

    var body: some View {
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

                            PlayerProfileView(name: name, imageNumber: imageNumber, bgColor: bgColorHex)
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
                                    .onChange(of: bgColor) { _ in
                                        // Save Hex value
                                        bgColorHex = bgColor.toHexString()
                                    }

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
                                print("Create/Modify Profile")
                                // TODO: 
                                // Save Profile
//                                let hexStringFromColor: String? = backgroundColor.toHexString(includeAlpha: false)

//                                do {
//                                    try await store.save(scrums: store.scrums)
//                                } catch {
//                                    fatalError(error.localizedDescription)
//                                }

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

            }.sheet(isPresented: $profileImagePressed) {
                ImageOptionsView(imageNumber: $imageNumber)
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ModifyProfileView()
}
