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
    let TEST_PLAYED_CARD_RESPONSE_1 = "PLAYED_CARD_1"
    let TEST_PLAYED_CARD_RESPONSE_2 = "PLAYED_CARD_2"
    let TEST_PLAYED_CARD_RESPONSE_3 = "PLAYED_CARD_3"
    let TEST_PLAYED_CARD_RESPONSE_4 = "PLAYED_CARD_4"
    let TEST_PLAYED_CARD_RESPONSE_5 = "PLAYED_CARD_5"
    let TEST_PLAYED_CARD_RESPONSE_6 = "PLAYED_CARD_6"

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
            if error != nil {
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
            if error != nil {
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
            if error != nil {
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
            if error != nil {
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
            if error != nil {
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
            if error != nil {
                XCTFail("Timeout waiting for RoundStatusResponse!")
            }
        }
    }
    func testPlayedCardResponse() {
        var request = ObjectDecodeTestRequest(id: id, for: TEST_PLAYED_CARD_RESPONSE_1)
        var responseExpectation = expectation(description: "Recieved Played Card Response with Base Result")
        stompClient.registerListener("/topic/test/decoding/\(id.uuidString.lowercased())") { payload in
            do {
                let jsonString = String(data: payload, encoding: .utf8)
                print("Payload: \(jsonString ?? "COULD NOT GET STRING")")
                let response = try JSONDecoder().decode(PlayedCardResponse.self, from: payload)
                XCTAssertNotNil(response)
                responseExpectation.fulfill()
                print("The decoded StartRoundResponse with result: \n\(response)")
            } catch {
                XCTFail("Unable to decode PlayedCardResponse!")
            }
        }
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail("Timeout waiting for PlayedCardResponse with base result!")
            }
        }
        responseExpectation = expectation(description: "Recieved Played Card Response with Duck Result")
        request = ObjectDecodeTestRequest(id: id, for: TEST_PLAYED_CARD_RESPONSE_2)
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail("Timeout waiting for PlayedCardResponse with duck result!")
            }
        }
        responseExpectation = expectation(description: "Recieved Played Card Response with Gazebo Result")
        request = ObjectDecodeTestRequest(id: id, for: TEST_PLAYED_CARD_RESPONSE_3)
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail("Timeout waiting for PlayedCardResponse with gazebo result!")
            }
        }
        responseExpectation = expectation(description: "Recieved Played Card Response with Maul Rat Result")
        request = ObjectDecodeTestRequest(id: id, for: TEST_PLAYED_CARD_RESPONSE_4)
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail("Timeout waiting for PlayedCardResponse with maul rat result!")
            }
        }
        responseExpectation = expectation(description: "Recieved Played Card Response with Net Troll Result")
        request = ObjectDecodeTestRequest(id: id, for: TEST_PLAYED_CARD_RESPONSE_5)
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail("Timeout waiting for PlayedCardResponse with net troll result!")
            }
        }
        responseExpectation = expectation(description: "Recieved Played Card Response with Potted Result")
        request = ObjectDecodeTestRequest(id: id, for: TEST_PLAYED_CARD_RESPONSE_6)
        stompClient.sendData(body: request, to: "/app/test/decoding")
        waitForExpectations(timeout: 10) { error in
            if error != nil {
                XCTFail("Timeout waiting for PlayedCardResponse with potted result!")
            }
        }
    }
    func testPlayCardRequest() {
        let player = Player(name: "Ben", id: UUID())
        let playerToPlayOn = Player(name: "Josh", id: UUID())
        let card1 = RegularCard(power: 4)
        let card2 = GuessingCard(power: 1, guessedOn: playerToPlayOn, guessedCard: 6)
        let card3 = TargetedCard(power: 5, playedOn: playerToPlayOn)
        let request1 = PlayCardRequest(roomKey: "SomeRoomKey", player: player, card: .regular(card1))
        let request2 = PlayCardRequest(roomKey: "SomeRoomKey", player: player, card: .guessing(card2))
        let request3 = PlayCardRequest(roomKey: "SomeRoomKey", player: player, card: .targeted(card3))

        stompClient.sendData(body: request1, to: "/app/test/encoding")
        stompClient.sendData(body: request2, to: "/app/test/encoding")
        stompClient.sendData(body: request3, to: "/app/test/encoding")
    }
}
