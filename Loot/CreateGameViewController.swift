//
//  CreateGameManager.swift
//  Loot
//
//  Created by Kenna Chase on 4/3/24.
//

import Foundation

final class CreateGameViewController: ObservableObject {
    enum Action {
        case none
        case present
        case dismiss
    }
    @Published private(set) var action: Action = .none

    func present() {
        // Prevent create game view from being presented multiple times
        guard !action.isPresented else { return }
        self.action = .present
    }

    func dismiss() {
        self.action = .dismiss
    }

}

extension CreateGameViewController.Action {
    var isPresented: Bool {
        self == .present
    }
}
