//
//  Card.swift
//  Loot
//
//  Created by Michael, Ben on 4/9/24.
//

import Foundation

class Card: ObservableObject, Identifiable, Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    let id = UUID()
    let number: Int
    var name: String = ""
    var description: String = ""
    @Published var faceDown: Bool = true
    init(number: Int) {
        self.number = number
    }
    init(from card: CardResponse) {
        self.number = card.power
        self.name = card.name
        self.description = card.description
    }
}

enum CardSize {
    case small, large
}
