//
//  GameLogViewExtension.swift
//  Loot
//
//  Created by Benjamin Michael on 4/14/24.
//

import SwiftUI

extension View {
    func withGameLog(for log: GameLog) -> some View {
        ZStack {
            self
            GameLogView(gameLog: log)
        }
    }
}
