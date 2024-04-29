//
//  Page1.swift
//  Loot
//
//  Created by Benjamin Michael on 4/23/24.
//

import SwiftUI

struct Page1: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Introduction")
                .font(.custom("Quasimodo", size: 28))
                .foregroundStyle(Color.black)
                .padding(.leading)
            Divider()
                .overlay(.gray)
                .padding(.horizontal)
            Section {
                Text(page1txt1)
                    .padding(.bottom)
                Text(page1txt2)
                    .padding(.bottom)
                Text(page1txt3)
            }
            .font(.custom("CaslonAntique", size: 24))
            .foregroundStyle(.black)
            .padding(.horizontal, 35)
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    Page1()
}
