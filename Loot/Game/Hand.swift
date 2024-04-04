//
//  Hand.swift
//  Loot
//
//  Created by Singontiko, Joshua on 4/2/24.
//

import Foundation

class Hand: ObservableObject, Identifiable {
    let id = UUID()
    @Published var cards = [Card]()
    @Published var shuffled = false
    func shuffleCards() {
        shuffled.toggle()
    }
}
