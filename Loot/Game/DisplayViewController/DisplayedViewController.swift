//
//  ViewDisplayController.swift
//  Loot
//
//  Created by Kenna Chase on 3/11/24.
//

import Foundation

class DisplayedViewController: ObservableObject {

    /**
     A common, shared instance of the View Display Controller that is available globally throughout the app.
     */
    public static let sharedViewDisplayController = DisplayedViewController()

    /** Published means there will be change notifications, so changes are automatically sent out to observers
     */
    @Published var currentView: ViewToDisplay = .startNewGameView

    @Published var previousView: ViewToDisplay = .startNewGameView

    func changeView(view: ViewToDisplay) {
        // check if in current view
        if view == currentView {
            return
        }

        previousView = currentView
        currentView = view
    }
}
