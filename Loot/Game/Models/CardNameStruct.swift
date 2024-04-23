//
//  CardNameStruct.swift
//  Loot
//
//  Created by Joshua Singontiko on 4/21/24.
//

import Foundation

struct CardNameStruct: Identifiable {
    var id = UUID()
    let card: Card
    let name: String
}

