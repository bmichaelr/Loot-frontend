//
//  UIHexColor.swift
//  Loot
//
//  Created by Kenna Chase on 4/22/24.
//

 import UIKit
import SwiftUI

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

extension Color {

    func toHexString(includeAlpha: Bool = false) -> String {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }

}
