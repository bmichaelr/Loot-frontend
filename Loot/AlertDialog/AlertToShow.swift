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
// -- MARK: Extenstion for view
extension View {
    func showCustomAlert<T: AppAlert>(alert: Binding<T?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "Error", isPresented: Binding(value: alert), actions: {
                alert.wrappedValue?.buttons
            }, message: {
                if let subtitle = alert.wrappedValue?.message {
                    Text(subtitle)
                }
            })
    }
}
// -- MARK: Protocol for the alerts to conform to
protocol AppAlert {
    var title: String { get }
    var message: String? { get }
    var buttons: AnyView { get }
}
// -- MARK: Custom Alert for use throughout the App
enum AlertToShow: Error, LocalizedError, AppAlert {
    case noInternetConnection(onOkPressed: () -> Void, onRetryPressed: () -> Void)
    case joinGame(gameName: String, onOkPressed: () -> Void)
    case serverError(errorReason: String)
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "Please check your internet connection and try again."
        case .joinGame:
            return "Attempting to join game"
        case .serverError:
            return "There was an issue with the request and the backend refused"
        }
    }
    var title: String {
        switch self {
        case .noInternetConnection:
            return "No Internet Connection"
        case .joinGame:
            return "Join Game"
        case .serverError:
            return "Error"
        }
    }
    var message: String? {
        switch self {
        case .noInternetConnection:
            return "Please check your internet connection and try again."
        case .joinGame(gameName: let gameName, _):
            return "Would you like to join \(gameName)?"
        case .serverError(errorReason: let errorReason):
            return errorReason
        }
    }
    var buttons: AnyView {
        AnyView(getButtonsForAlert)
    }
    @ViewBuilder var getButtonsForAlert: some View {
        switch self {
        case .noInternetConnection(onOkPressed: let onOkPressed, onRetryPressed: let onRetryPressed):
            Button("OK") {
                onOkPressed()
            }
            Button("RETRY") {
                onRetryPressed()
            }
        case .joinGame(_, onOkPressed: let onOkPressed):
            Button("No") { }
            Button("Yes") {
                onOkPressed()
            }
        case .serverError:
            Button("Okay") { }
        }
    }
}
