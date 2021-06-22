//
//  Endpoint.swift
//  
//
//  Created by Caio Mello on 22.06.21.
//

import Foundation

public protocol Endpoint {
    var method: HTTPMethod { get }
    var host: String { get }
    var path: String { get }

    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var payload: Data? { get }
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }

    var request: URLRequest { get throws }
}

public extension Endpoint {
    var queryItems: [URLQueryItem]? {
        nil
    }

    var headers: [String: String]? {
        nil
    }

    var payload: Data? {
        nil
    }

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        .deferredToDate
    }

    var request: URLRequest {
        get throws {
            var components = URLComponents()
            components.scheme = "https"
            components.host = host
            components.path = path
            components.queryItems = queryItems

            guard let url = components.url else {
                throw NetworkingError.invalidURL
            }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            request.httpBody = payload
            return request
        }
    }
}
