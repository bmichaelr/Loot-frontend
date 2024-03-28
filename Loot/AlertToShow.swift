//
//  AlertToShow.swift
//  Loot
//
//  Created by Benjamin Michael on 3/27/24.
//

import Foundation
import SwiftUI

// -- MARK: Extension for binding to allow the use of custom data types
extension Binding where Value == Bool {
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { updatedVal in
            if !updatedVal {
                value.wrappedValue = nil
            }
        }
    }
}
// -- MARK: Protocol for the alerts to conform to
protocol AppAlert {
    var title: String { get }
    var message: String? { get }
    var buttonText: String? { get }
}
// -- MARK: Custom Alert for use throughout the App
enum AlertToShow: Error, LocalizedError, AppAlert {
    case joinGame, unableToConnectToSocket, disconnectedFromSocket, socketInterruption
    
    var title: String {
        switch self {
        case .joinGame:
            return "Join Game"
        case .unableToConnectToSocket:
            return "Connection Failed"
        case .disconnectedFromSocket:
            return "Connection Lost"
        case .socketInterruption:
            return "Server Error"
        }
    }
    var message: String? {
        switch self {
        case .joinGame:
            return "Would you like to join"
        case .unableToConnectToSocket:
            return "Unable to connect to the server, please try again."
        case .disconnectedFromSocket:
            return "Connection to the server lost. Exiting..."
        case .socketInterruption:
            return "Something went wrong. Please try again later."
        }
    }
    var buttonText: String? {
        switch self {
        case .joinGame:
            return "Yes"
        default:
            return nil
        }
    }
}
