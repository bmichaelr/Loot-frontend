//
//  RoundedCornerRect.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    RoundedCorner(corners: [.topLeft, .bottomLeft])
        .frame(width: 150, height: 200)
}
