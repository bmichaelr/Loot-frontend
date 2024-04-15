//
//  PlayerProfileView.swift
//  Loot
//
//  Created by Kenna Chase on 4/15/24.
//

import SwiftUI

struct PlayerProfileView: View {
    @State var name: String = "Name"
    private var imageName: String = "loot_"
    @State private var imageNumber: Int = 1
    @State private var bgColor =
            Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    @State private var profileImagePressed = false

    var body: some View {
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

                        // Profile Image
                        ZStack {
                            Circle()
                                .fill(Color(bgColor))
                            Image(imageName + String(imageNumber))
                                .resizable()
                                .padding()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

                        }
                        .padding()
                        .frame(width: 200, height: 200, alignment: .center)
                        .onTapGesture {
                            profileImagePressed.toggle()
                        }

                        // Change Profile Image & Background
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.left")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.lootBeige)
                                .padding()
                                .onTapGesture {
                                    // Decrement Image
                                    if imageNumber - 1 > 0 {
                                        imageNumber -= 1
                                    } else {
                                        imageNumber = 8
                                    }
                                }

                            Image(systemName: "arrow.right")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.lootBeige)
                                .padding()
                                .onTapGesture {
                                    // Increment Image
                                    if imageNumber + 1 <= 8 {
                                        imageNumber += 1
                                    } else {
                                        imageNumber = 0
                                    }
                                }

                            ColorPicker("", selection: $bgColor, supportsOpacity: false)
                                .multilineTextAlignment(.center)
                                .accentColor(.red)

                            Spacer()
                        }

                        // Change Profile Name
                        CustomTextField(text: $name, prompt: "Your Name").multilineTextAlignment(.center)

                    }

                }

                .padding([.leading, .trailing], 20)

            }.padding()
        }.sheet(isPresented: $profileImagePressed) {
            ImageOptionsView(imageNumber: $imageNumber)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    PlayerProfileView()
}
