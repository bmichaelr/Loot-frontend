//
//  Hand.swift
//  Loot
//
//  Created by Michael, Ben on 4/9/24.
//

import Foundation

class Hand: ObservableObject, Identifiable {
    let id = UUID()
    @Published var cards = [Card]()
}

enum HandType {
    case holding, discard
}
