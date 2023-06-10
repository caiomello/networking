//
//  NetworkingClient.swift
//  
//
//  Created by Caio Mello on 22.06.21.
//

import Foundation
import OSLog

public struct NetworkingClient {
    private let session: URLSession
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: Self.self))

    public init(session: URLSession = .shared) {
        self.session = session
    }
}

// MARK: - Operations

extension NetworkingClient {
    public func object<T: Decodable>(at endpoint: Endpoint, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let urlString = (try? endpoint.request.url?.absoluteString) ?? "INVALID URL"

        var statusCode: Int?

        do {
            let request = try endpoint.request

            logger.trace("[\(endpoint.method.rawValue)] \(urlString, privacy: .private)")

            let (data, response) = try await session.data(for: request)

            statusCode = (response as? HTTPURLResponse)?.statusCode

            if let statusCode, let error = NetworkingError(statusCode: statusCode) {
                throw error
            }

            decoder.dateDecodingStrategy = endpoint.dateDecodingStrategy

            let object = try decoder.decode(T.self, from: data)

            logger.notice("[\(endpoint.method.rawValue)] [\(statusCode ?? 0)] \(urlString, privacy: .private)")

            return object

        } catch {
            logger.error("[\(endpoint.method.rawValue)] [\(statusCode ?? 0)] \(urlString, privacy: .private) - \(error)")
            throw error
        }
    }
}
