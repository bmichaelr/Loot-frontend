//
//  StompClient.swift
//  Loot
//
//  Created by Benjamin Michael on 3/13/24.
//

import Foundation
import SwiftStomp

class StompClient {
    let swiftStomp: SwiftStomp
    var channelListeners: [String: (Data) -> Void] = [:]
    var connectedCall: ((Bool) -> Void)?
    var debug: Bool = false
    private var gameRoomName: String = ""
    var buttonClickable: Bool {
        gameRoomName.count > 0
    }
    init() {
        let urlString = debug ? "http://localhost:8080/game-websocket" : "http://ciloot.lol:8080/game-websocket"
        let url = URL(string: urlString)
        swiftStomp = SwiftStomp(host: url!)
        swiftStomp.delegate = self
        swiftStomp.autoReconnect = true
    }
    init(_ debugUrl: String) {
        let url = URL(string: debugUrl)
        swiftStomp = SwiftStomp(host: url!)
        swiftStomp.delegate = self
        swiftStomp.autoReconnect = true
    }
    func registerListener(_ url: String, using function: @escaping (Data) -> Void) {
        channelListeners[url] = function
        swiftStomp.subscribe(to: url, mode: .clientIndividual)
    }
    func sendData<T: Codable>(body: T, to url: String) {
        if let stringBody = body as? String {
            swiftStomp.send(body: stringBody, to: url)
            return
        }
        do {
            let jsonData = try JSONEncoder().encode(body)
            let jsonString = String(data: jsonData, encoding: .utf8)
            swiftStomp.send(body: jsonString!, to: url, headers: ["content-type": "application/json"])
        } catch {
            // Possible better error handling in the future
            print("Error sending data \(error)")
        }
    }
    func connect(connected: @escaping (Bool) -> Void) {
        connectedCall = connected
        swiftStomp.connect()
    }
    func unregisterListener(_ url: String) {
        swiftStomp.unsubscribe(from: url, mode: .clientIndividual)
    }
}

extension StompClient: SwiftStompDelegate {
    func onSocketEvent(eventName: String, description: String) {
        // Handle socket event
        print(eventName, description)
    }
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("connected to server", connectType)
        if connectType == .toStomp {
            print("Connected to stomp")
            if let call = connectedCall {
                call(true)
            }
        } else if connectType == .toSocketEndpoint {
            print("connected to socket")
        }
    }
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        // Handle disconnection
    }
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String: String]) {
        if let message = message as? String {
            guard let payload = message.data(using: .utf8) else {
                print("Unable to decode payload")
                return
            }
            if let function = channelListeners[destination] {
                function(payload)
            } else {
                print("There is no subscription found for \(destination)")
            }
        } else {
            print("Message in some other format than string")
        }
    }
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        // Handle receipt
        print("received: ", receiptId)
    }
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        // Handle error
        print("error occured in connection: \(briefDescription), full description: \(fullDescription ?? "not available")")
    }
}
