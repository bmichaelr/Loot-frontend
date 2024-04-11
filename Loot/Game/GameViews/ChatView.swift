//
//  ChatView.swift
//  Loot
//
//  Created by Michael, Ben on 4/11/24.
//

import SwiftUI

var data: [String] {
    var data = [String]()
    data.append(contentsOf: [
        "Josh just played maul rat on ben",
        "It is now bens turn",
        "Ben played wishing ring, he is safe",
        "Ian played duck of doom on kenna, ian lost",
        "josh played potted plant on kenna, he guesed maul rat and was wrong"
    ])
    return data
}

struct ChatView: View {
    @EnvironmentObject var model: GameState
    var width: CGFloat
    var offset: CGFloat
    @State private var chatOffset: CGFloat
    @State private var isShowing: Bool = false
    init() {
        width = UIScreen.main.bounds.width * 0.66
        offset = width
        chatOffset = offset
    }
    var body: some View {
        HStack {
            Spacer()
            VStack {
                ZStack {
                    Log(data: $model.messages)
                        .frame(width: width)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2.0)
                        }
                        .shadow(radius: 10)
                    PopoutButton()
                        .offset(x: -(width / 2) - 10)
                        .shadow(radius: 5)
                        .onTapGesture {
                            withAnimation(.spring) {
                                if isShowing {
                                    chatOffset = offset
                                } else {
                                    chatOffset = 0
                                }
                                isShowing.toggle()
                            }
                        }
                }
            }
        }
        .offset(x: chatOffset)
    }
}

struct PopoutButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 20, height: 50)
                .foregroundStyle(Color.lootGreen)
                .overlay {
                    RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1.5)
                }
            VStack(spacing: 5) {
                Circle()
                    .frame(width: 9, height: 9)
                    .foregroundStyle(Color.black)
                Circle()
                    .frame(width: 9, height: 9)
                    .foregroundStyle(Color.black)
                Circle()
                    .frame(width: 9, height: 9)
                    .foregroundStyle(Color.black)
            }
        }
    }
}

struct Log: View {
    var data: Binding<[String]>
    let height = UIScreen.main.bounds.height - 120
    var body: some View {
        VStack {
            Text("Game Event Log")
                .font(.custom("Quasimodo", size: 24))
                .foregroundStyle(Color.lootBeige)
                .padding()
                .padding(.top)
            Divider()
            ScrollView {
                ForEach(data.indices, id: \.self) { index in
                    let message = data[index]
                    LogItem(text: message.wrappedValue)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 5)
                }
            }
        }
        .frame(maxHeight: height)
        .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(Color.lootBrown))
    }
}

struct LogItem: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
                .padding(10)
        }
        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.gray))
        .overlay {
            RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 2.0)
        }
    }
}

extension View {
    func chatOverlay() -> some View {
        ZStack {
            self
            ChatView()
        }
    }
}
