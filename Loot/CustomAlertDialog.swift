//
//  CustomAlertDialog.swift
//  Loot
//
//  Created by Benjamin Michael on 3/26/24.
//

import SwiftUI

struct CustomAlertDialog: ViewModifier {
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    @State private var offset: CGFloat = 1000
    var isPresented: Binding<Bool>
    init(isPresented: Binding<Bool>) {
        self.isPresented = isPresented
    }
    mutating func body(content: Content) -> some View {
        content.overlay(alertContent())
    }
    @ViewBuilder
    private mutating func alertContent() -> some View {
        ZStack {
            Color.black
                .opacity(0.15)
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
                        self.close()
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
                }
            }
        }
    }
    private mutating func close() {
        withAnimation(.spring) {
            offset = 1000
            isPresented.wrappedValue.toggle()
        }
    }
}
func customAlert(isPresented: Binding<Bool>) -> some View {
    return modifier(CustomAlertDialog(isPresented: isPresented))
}
