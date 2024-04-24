//
//  Profile.swift
//  Loot
//
//  Created by Kenna Chase on 4/23/24.
//

import Foundation

struct Profile: Identifiable, Codable {
    var id: UUID
    var name: String
    var background: String // Hex
    var imageNum: Int

    init(id: UUID, name: String, background: String, imageNum: Int) {
        self.id = id
        self.name = name
        self.background = background
        self.imageNum = imageNum
    }
    init() {
        self.id = UUID()
        self.name = ""
        self.background = "#000000"
        self.imageNum = 1
    }

   // func generateUUID(name: String) -> UUID {
   //                // TODO: Implement UUID ...
   //                return 0
   //            }
}
