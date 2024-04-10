//
//  ErrorResponse.swift
//  Loot
//
//  Created by Benjamin Michael on 4/9/24.
//

import Foundation

struct ErrorResponse: Codable {
    let details: String
    let code: Int?
}
