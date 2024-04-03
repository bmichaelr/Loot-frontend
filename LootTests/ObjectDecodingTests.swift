//
//  ObjectDecodingTests.swift
//  Loot
//
//  Created by Benjamin Michael on 4/2/24.
//

import Foundation
@testable import Loot
import XCTest

final class ObjectDecodingTests: XCTestCase {
    let TEST_LOBBY_RESPONSE = "LOBBY_RESPONSE"
    let TEST_SERVERS_RESPONSE = "SERVERS_RESPONSE"
    let TEST_GAME_PLAYER_RESPONSE = "GAME_PLAYER"
    let TEST_START_ROUND_RESPONSE = "START_ROUND"
    let TEST_NEXT_TURN_RESPONSE = "NEXT_TURN"
    let TEST_ROUND_STATUS_RESPONSE = "ROUND_STATUS"
    let TEST_PLAYED_CARD_RESPONSE = "PLAYED_CARD"
    struct ObjectDecodeTestRequest: Codable {
        let id: String
        let type: String
        
        init(id: UUID, for response: String) {
            self.id = id.uuidString.lowercased()
            self.type = response
        }
    }
    var stompClient: StompClient!
    let id: UUID = UUID()
    override func setUp() {
        super.setUp()
        self.stompClient = StompClient("http://192.168.1.93:8080/game-websocket")
        let connectExpectation = expectation(description: "Stomp Client Connection Successful")
        stompClient.connect { status in
            XCTAssertTrue(status)
            connectExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout waiting for connection!")
            }
        }
    }
    override func tearDown() {
        stompClient.swiftStomp.disconnect()
        super.tearDown()
    }
    func testLobbyResponseDecode() {
        let request = ObjectDecodeTestRequest(id: id, for: TEST_LOBBY_RESPONSE)
        let responseExpectation = expectation(description: "Recieved Lobby Response")
        
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { data in
            do {
                let lobbyResponse = try JSONDecoder().decode(LobbyResponse.self, from: data)
                XCTAssertNotNil(lobbyResponse)
                responseExpectation.fulfill()
            } catch {
                XCTFail("Unable to decode the lobby response")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout wating for lobby response! \(error)")
            }
        }
    }
    func testServersResponseDecode() {
        let request = ObjectDecodeTestRequest(id: id, for: TEST_SERVERS_RESPONSE)
        let responseExpectation = expectation(description: "Recieved Available Servers Response")
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { payload in
            do {
                let response = try JSONDecoder().decode([ServerResponse].self, from: payload)
                XCTAssertNotNil(response)
                responseExpectation.fulfill()
            } catch {
                XCTFail("Unable to decode server list response!")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout waiting for server list response!")
            }
        }
    }
    func testGamePlayerResponseDecode() {
        let request = ObjectDecodeTestRequest(id: id, for: TEST_GAME_PLAYER_RESPONSE)
        let responseExpectation = expectation(description: "Recieved Game Player Response")
        
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { payload in
            do {
                let response = try JSONDecoder().decode(Player.self, from: payload)
                XCTAssertNotNil(response)
                responseExpectation.fulfill()
            } catch {
                XCTFail("Unable to decode GamePlayer response!")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout waiting for Game Player response!")
            }
        }
    }
    func testStartRoundResponseDecode() {
        let request = ObjectDecodeTestRequest(id: id, for: TEST_START_ROUND_RESPONSE)
        let responseExpectation = expectation(description: "Recieved Start Round Response")
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { payload in
            do {
                let response = try JSONDecoder().decode(StartRoundResponse.self, from: payload)
                XCTAssertNotNil(response)
                responseExpectation.fulfill()
            } catch {
                XCTFail("Unable to decode StartRoundResponse!")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout waiting for StartRoundResponse!")
            }
        }
    }
    func testNexTurnResponse() {
        let request = ObjectDecodeTestRequest(id: id, for: TEST_NEXT_TURN_RESPONSE)
        let responseExpectation = expectation(description: "Recieved NextTurnResponse")
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { payload in
            do {
                let response = try JSONDecoder().decode(NextTurnResponse.self, from: payload)
                XCTAssertNotNil(response)
                responseExpectation.fulfill()
            } catch {
                XCTFail("Unable to decode NextTurnResponse!")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout waiting for NextTurnResponse!")
            }
        }
    }
    func testRoundStatusResponse() {
        let request = ObjectDecodeTestRequest(id: id, for: TEST_ROUND_STATUS_RESPONSE)
        let responseExpectation = expectation(description: "Recieved Round Status Response")
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { payload in
            do {
                let response = try JSONDecoder().decode(RoundStatusResponse.self, from: payload)
                XCTAssertNotNil(response)
                responseExpectation.fulfill()
            } catch {
                XCTFail("Unable to decode RoundStatusResponse!")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout waiting for RoundStatusResponse!")
            }
        }
    }
    func testPlayedCardResponse() {
        let request = ObjectDecodeTestRequest(id: id, for: TEST_PLAYED_CARD_RESPONSE)
        let responseExpectation = expectation(description: "Recieved Played Card Response")
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { payload in
            do {
                let response = try JSONDecoder().decode(PlayedCardResponse.self, from: payload)
                XCTAssertNotNil(response)
                responseExpectation.fulfill()
                print("The decoded StartRoundResponse: \n\(response)")
            } catch {
                XCTFail("Unable to decode PlayedCardResponse!")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("Timeout waiting for PlayedCardResponse!")
            }
        }
    }
}

