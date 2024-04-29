//
//  SideMenuTab.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import SwiftUI

struct SideMenuTab: View {
    @Binding var open: Bool
    var body: some View {
        ZStack {
            RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft])
                .frame(width: 25, height: 75)
                .foregroundStyle(Color.lootBrown)
            RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft])
                .frame(width: 15, height: 65)
                .foregroundStyle(Color.lootBeige)
            Image(systemName: "chevron.left")
                .rotationEffect(open ? Angle(degrees: 180) : .zero)
                .foregroundStyle(Color.black)
                .shadow(radius: 20)
        }
    }
}

struct SideMenuTab_Previews: PreviewProvider {
    struct Wrapper: View {
        @State private var open = false
        var body: some View {
            SideMenuTab(open: $open)
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
