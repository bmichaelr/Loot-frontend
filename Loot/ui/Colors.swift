//
//  Colors.swift
//  Loot
//
//  Created by Michael, Ben on 3/26/24.
//

import Foundation
import SwiftUI

extension Color {
    static let lootBrown: Color = Color(hex: "#4B1E18")
    static let lootBeige: Color = Color(hex: "#EED9A2")
    static let lootGreen: Color = Color(hex: "#57A955")
}
extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
