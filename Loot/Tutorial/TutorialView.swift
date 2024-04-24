//
//  TutorialView.swift
//  Loot
//
//  Created by ian on 4/18/24.
//

import SwiftUI

struct TutorialView: View {
    var pages: [AnyView] = [
        AnyView(Page1()),
        AnyView(Page2()),
        AnyView(Page3()),
        AnyView(Page4()),
        AnyView(Page5()),
        AnyView(Page6()),
        AnyView(Page7()),
        AnyView(Page8()),
        AnyView(Page9()),
        AnyView(Page10())
    ]
    var body: some View {
        ZStack {
            Color.lootBrown.ignoresSafeArea(.all)
            VStack {
                Text("Tutorial")
                    .font(.custom("Quasimodo", size: 25))
                    .foregroundStyle(Color.lootBeige)
                TabView {
                    ForEach(0..<pages.count, id: \.self) { index in
                        ZStack {
                            self.pages[index]
                                .padding(.vertical)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 40)
                                .foregroundStyle(Color.lootBeige)
                        }
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .padding(10)
        }
    }
}

#Preview {
    TutorialView()
}
