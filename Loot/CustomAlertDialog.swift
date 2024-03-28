//
//  CustomAlertDialog.swift
//  Loot
//
//  Created by Benjamin Michael on 3/26/24.
//

import SwiftUI

extension View {
    func customAlertDialog(title: String, message: String, buttonTitle: String, action: @escaping () -> Void, isActive: Binding<Bool>) -> some View {
        return ZStack {
            self
            if isActive.wrappedValue {
                CustomAlertDialog(title: title, message: message, buttonTitle: buttonTitle, action: action, isActive: isActive)
            }
        }
    }
}

struct CustomAlertDialogTest: View {
    @State private var showAlert: Bool = false
    var body: some View {
        VStack {
            Button {
                showAlert.toggle()
            } label: {
                Text("Press me")
            }
        }
        .customAlertDialog(title: "Hello", message: "You have brought up the alert dialog!", buttonTitle: "Awesome", action: doSomethingCool, isActive: $showAlert)
    }
    private func doSomethingCool() {
        print("Oh yeah, we are doing something cool 😎")
    }
}

struct CustomAlertDialog: View {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    @State private var offset: CGFloat = 1000
    @State private var opacity: Double = 0.0
    @Binding var isActive: Bool
    var body: some View {
        ZStack {
            Color.black
                .opacity(opacity)
                .ignoresSafeArea()
                .onTapGesture {
                    close()
                }
            VStack {
                Text(title)
                    .font(.custom("Quasimodo", size: 28))
                    .foregroundStyle(Color.lootBeige)
                    .padding([.leading, .trailing, .top], 20)
                Divider()
                    .frame(height: 1)
                    .background(Color.black)
                Text(message)
                    .font(.custom("Quasimodo", size: 18))
                    .foregroundStyle(Color.lootBeige)
                    .multilineTextAlignment(.center)
                    .padding()
                HStack {
                    Button {
                        close()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.red)
                            Text("No")
                                .font(.custom("Quasimodo", size: 22))
                                .foregroundStyle(.black)
                                .padding()
                        }
                    }
                    Button {
                        action()
                        close()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.lootGreen)
                            Text(buttonTitle)
                                .font(.custom("Quasimodo", size: 22))
                                .foregroundStyle(.black)
                                .padding()
                        }
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.lootBrown)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
            .padding(30)
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                    opacity = 0.15
                }
            }
        }
    }
    private func close() {
        withAnimation(.spring) {
            offset = 1000
            opacity = 0
            isActive = false
        }
    }
}

#Preview {
    CustomAlertDialogTest()
}
