//
//  CustomViews.swift
//  Loot
//
//  Created by Michael, Ben on 4/3/24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    let prompt: String
    var body: some View {
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
            TextField(prompt, text: $text)
                .font(Font.custom("Quasimodo", size: 14).weight(.medium))
                .foregroundStyle(.black)
                .focused($isFocused)
                .autocorrectionDisabled(true)
                .padding(.leading, 20)
        }
    }
}
struct CustomButton: View {
    @State private var buttonClicked: Bool = false
    @State private var scaleEffect: CGFloat = 1.0
    let text: String
    let onClick: () -> Void
    var enabled: Bool = true
    var buttonColor: Color = Color.lootGreen
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 50)
                .background(enabled ? buttonColor : Color.gray)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 2)
                )
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                )
                .scaleEffect(scaleEffect)
            Text(text)
                .font(Font.custom("Quasimodo", size: 16).weight(.medium))
                .foregroundColor(.black)
        }
        .onTapGesture {
            if !enabled { return }
            withAnimation {
                scaleEffect = 0.9
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    scaleEffect = 1.0
                    onClick()
                }
            }
        }
    }
}
