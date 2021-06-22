//
//  NetworkingClient.swift
//  
//
//  Created by Caio Mello on 22.06.21.
//

import Foundation

public struct NetworkingClient {
    private let logger = Logger()
}

// MARK: - Operations

extension NetworkingClient {
    public func object<T: Decodable>(at endpoint: Endpoint) async throws -> T {
        do {
            let request = try endpoint.request

            logger.log(endpoint: endpoint, type: .requestFired)

            let (data, response) = try await URLSession.shared.data(for: request)

            if let statusCode = (response as? HTTPURLResponse)?.statusCode, let error = NetworkingError(statusCode: statusCode) {
                logger.log(endpoint: endpoint, response: response, type: .failure(error))
                throw error
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = endpoint.dateDecodingStrategy

            let object = try decoder.decode(T.self, from: data)

            logger.log(endpoint: endpoint, response: response, type: .success)

            return object

        } catch {
            logger.log(endpoint: endpoint, type: .failure(error))
            throw error
        }
    }
}
