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
