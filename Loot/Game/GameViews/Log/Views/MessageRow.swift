//
//  MessageRow.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import SwiftUI

struct MessageRow: View {
    let message: Message
    var body: some View {
        HStack {
            Text(message.text)
                .font(.custom("CaslonAntique", size: 20))
                .foregroundStyle(Color.black)
            Spacer()
            Image(systemName: message.type.getImage())
                .foregroundStyle(message.type.getColor())
        }
        .padding(.horizontal, 15).padding(.vertical, 2)
    }
}
#Preview {
    MessageRow(message: Message(text: "It is now Edward's turn", type: .turnUpdate))
}
