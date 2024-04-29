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
    static let lootRed: Color = Color(hex: "#921717")
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
    func toHexString(includeAlpha: Bool = false) -> String {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }
}

extension UIColor {
    // Returns a hex string representation of the UIColor instance
    func toHexString(includeAlpha: Bool = false) -> String {
        // Get the red, green, and blue components of the UIColor as floats between 0 and 1
        guard let components = self.cgColor.components else {
            // If the UIColor's color space doesn't support RGB components, return nil
            return "#000000"
        }

        // Convert the red, green, and blue components to integers between 0 and 255
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)

        // Create a hex string with the RGB values and, optionally, the alpha value
        let hexString: String
        if includeAlpha, let alpha = components.last {
            let alphaValue = Int(alpha * 255.0)
            hexString = String(format: "#%02X%02X%02X%02X", red, green, blue, alphaValue)
        } else {
            hexString = String(format: "#%02X%02X%02X", red, green, blue)
        }

        // Return the hex string
        return hexString
    }
 }
