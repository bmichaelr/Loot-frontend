//
//  APIRequest.swift
//  Loot
//
//  Created by Michael, Ben on 4/18/24.
//

import Foundation
import SwiftUI

enum Endpoint: String, CaseIterable {
    case createPlayer = "/api/player/create"
    case updatePlayer = "/api/player/update"
    case getPlayer = "/api/player/get"
    case deletePlayer = "/api/player/delete"
    func getStringLiteral() -> String {
        switch self {
        case .createPlayer: "/api/player/create"
        case .updatePlayer: "/api/player/update"
        case .getPlayer: "/api/player/get"
        case .deletePlayer: "/api/player/delete"
        }
    }
    func getHttpRequestType() -> String {
        switch self {
        case .createPlayer: "POST"
        case .getPlayer: "GET"
        case .updatePlayer: "PUT"
        case .deletePlayer: "DELETE"
        }
    }
}

protocol ApiError {
    var reason: String { get }
    var httpCode: Int { get }
}

struct ApiThrownError: Error, LocalizedError, ApiError {
    var reason: String
    var httpCode: Int
    private static func getErrorReason(code: Int, endpoint: Endpoint) -> String {
        switch code {
        case 400:
            return "Invalid Request!"
        case 404:
            return "Unable to find resource! Please make sure the identifying value is correct."
        case 409:
            return "Resource already exists, please try again."
        default:
            return "Unknown error code!"
        }
    }
    static func buildFrom(code: Int, for endpoint: Endpoint) -> ApiThrownError {
        let reason = getErrorReason(code: code, endpoint: endpoint)
        return ApiThrownError(reason: reason, httpCode: code)
    }
}

struct DummyResponse: Decodable { }

public class APIRequest<Response: Decodable> {
    private final let baseUrl = "localhost"
    private final let endpoint: Endpoint
    private var responseCode: Int = 200
    // Optional Parameters
    private var headerParams: [String: String]?
    private var requestBody: Data?
    private var decodeResponse: Bool = false
    private var handler: ((Bool, Response?, ApiThrownError?) -> Void)?
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
    @discardableResult
    func withJsonBody<T: Encodable>(body: T) -> APIRequest {
        do {
            let encoder = JSONEncoder()
            self.requestBody = try encoder.encode(body)
        } catch {
            print("Unable to encode JSON body!")
        }
        return self
    }
    @discardableResult
    func withHeaderParams(parameters: [String: String]) -> APIRequest {
        self.headerParams = parameters
        return self
    }
    @discardableResult
    func expectingResponse() -> APIRequest {
        self.decodeResponse = true
        return self
    }
    @discardableResult
    func expectResponseCode(code: Int) -> APIRequest {
        self.responseCode = code
        return self
    }
    @discardableResult
    func withHandler(callback: @escaping (Bool, Response?, ApiThrownError?) -> Void) -> APIRequest {
        self.handler = callback
        return self
    }
    private func makeUrlComponents() -> URLComponents {
        // Build the URL comp object (scheme, endpoint, and header params if present)
        var components = URLComponents()
        components.scheme = "http"
        components.host = baseUrl
        components.port = 8080
        components.path = endpoint.getStringLiteral()
        if let headerParams = headerParams {
            components.queryItems = headerParams.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
        }
        return components
    }
    private func makeHttpURLRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.getHttpRequestType()
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let requestBody = requestBody {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestBody
        }
        return request
    }
    func call() {
        let urlComponents = makeUrlComponents()
        guard let url = urlComponents.url else {
            print("Unable to create URL components!")
            return
        }
        guard let callback = handler else {
            print("ERROR : Must specify a callback function of type (Bool, <T: Decodable>? to handle the call!")
            return
        }
        let request = makeHttpURLRequest(for: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var success: Bool
            var code = -1
            if let httpCode = response as? HTTPURLResponse {
                code = httpCode.statusCode
                success = httpCode.statusCode == self.responseCode
            } else {
                success = false
            }
            if self.decodeResponse {
                if let data = data {
                    let decodedData = try? JSONDecoder().decode(Response.self, from: data)
                    if let decodedData = decodedData {
                        callback(success, decodedData, nil)
                    } else {
                        let error = ApiThrownError.buildFrom(code: code, for: self.endpoint)
                        callback(false, nil, error)
                    }
                } else {
                    let error = ApiThrownError.buildFrom(code: code, for: self.endpoint)
                    callback(false, nil, error)
                }
            } else {
                callback(success, nil, nil)
            }
        }.resume()
    }
}

struct PlayerAccount: Codable {
    let uuid: UUID
    let uniqueName: String
    var name: String
    var profilePicture: Int
    var profileColor: String
}

let examplePlayer = PlayerAccount(uuid: UUID(),
                                  uniqueName: "ben.michael#1234",
                                  name: "Ben",
                                  profilePicture: 8,
                                  profileColor: "#FFFFFF")

class ConnectViewModel: ObservableObject {
    @Published var callInProgress: Bool = false
    @Published var playerAccountInText = ""
    func createPlayerAccount(account: PlayerAccount) {
        APIRequest<DummyResponse>(endpoint: .createPlayer)
            .expectResponseCode(code: 201)
            .withJsonBody(body: account)
            .withHandler(callback: handleResponselessCallback)
            .call()
    }
    func updatePlayerAccount(id: UUID, newName name: String) {
        APIRequest<DummyResponse>(endpoint: .updatePlayer)
            .withHeaderParams(parameters: ["id": id.uuidString, "name": name])
            .withHandler(callback: handleResponselessCallback)
            .call()
    }
    func deletePlayerAccount(id: UUID) {
        APIRequest<DummyResponse>(endpoint: .deletePlayer)
            .withHeaderParams(parameters: ["id": id.uuidString])
            .withHandler(callback: handleResponselessCallback)
            .call()
    }
    func getPlayerAccountInformation(id: UUID) {
        APIRequest<PlayerAccount>(endpoint: .getPlayer)
            .expectingResponse()
            .withHeaderParams(parameters: ["id" : id.uuidString])
            .withHandler(callback: handleResponseWithBody)
            .call()
    }
    func handleResponselessCallback(status: Bool, data: DummyResponse?, error: ApiThrownError?) {
        if status {
            print("Call was successful!")
            return
        }
        if let error = error {
            print("Call failed, error: \(error.reason)")
        }
    }
    func handleResponseWithBody(status: Bool, data: PlayerAccount?, error: ApiThrownError?) {
        if status {
            if let data = data {
                print("Call was successful, data: \(data)")
                playerAccountInText = getStringRepresentation(of: data)
            }
            return
        }
        if let error = error {
            print("Call failed, error: \(error.reason)")
        }
    }
    private func getStringRepresentation(of player: PlayerAccount) -> String {
        return """
                {
                    id: \(player.uuid.uuidString),
                    name: \(player.name),
                    uniqueName: \(player.uniqueName),
                    profilePicture: \(player.profilePicture),
                    profileColor: \(player.profileColor)
                }
                """
    }
}

struct ApiRequestView: View {
    @StateObject var viewModel = ConnectViewModel()
    @State var updatedName: String = ""
    var body: some View {
        VStack {
            Button("Make create call") {
                viewModel.createPlayerAccount(account: examplePlayer)
            }
            TextField("Enter in a new name...", text: $updatedName)
            Button("Make an update call") {
                viewModel.updatePlayerAccount(id: examplePlayer.uuid, newName: updatedName)
            }
            Button("Make a delete call") {
                viewModel.deletePlayerAccount(id: examplePlayer.uuid)
            }
            Button("Make a get call") {
                viewModel.getPlayerAccountInformation(id: examplePlayer.uuid)
            }
            Text("The retrieved player model:")
            Text(viewModel.playerAccountInText)
        }
        .padding()
        .buttonStyle(DefaultButtonStyle())
    }
}

#Preview {
    ApiRequestView()
}
