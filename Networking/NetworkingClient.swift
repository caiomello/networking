//
//  NetworkingClient.swift
//  Networking
//
//  Created by Caio Mello on April 25, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public struct NetworkingClient {
	let session: URLSession
	let timeoutInterval: TimeInterval
	let loggingEnabled: Bool

    public init(session: URLSession = .shared, timeoutInterval: TimeInterval = 30, loggingEnabled: Bool = true) {
        self.session = session
        self.timeoutInterval = timeoutInterval
        self.loggingEnabled = loggingEnabled
    }
}

// MARK: - Requests

extension NetworkingClient {
    @discardableResult public func request<T: Decodable>(_ url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
        let request = URLRequest(url: url, parameters: parameters, headers: headers, timeoutInterval: timeoutInterval)

        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                if let connectionError = NetworkingError(response: response, error: error) { throw connectionError }

                guard let data = data else { throw NetworkingError.noData }

                let object = try decoder.decode(T.self, from: data)

                self.log(request: request, type: .success)

                DispatchQueue.main.async {
                    completion(.success(object))
                }

            } catch let error as NetworkingError {
                self.log(request: request, type: .failure(error))

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } catch let error as DecodingError {
                self.log(request: request, type: .failure(error))

                DispatchQueue.main.async {
                    completion(.failure(NetworkingError(decodingError: error)))
                }
            } catch {
                self.log(request: request, type: .failure(error))

                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
            }
        })

        log(request: request, type: .requestFired)

        task.resume()

        return task
    }
}

// MARK: - Logging

extension NetworkingClient {
    private enum LoggingType {
        case requestFired
        case success
        case failure(Error)
    }

    // swiftlint:disable localizable_strings
    private func log(request: URLRequest, type: LoggingType) {
        if isDebug() {
            return
        }

        let log = "[\(request.httpMethod!)] \(request.url!.absoluteString)"

        switch type {
        case .requestFired:
            if let body = request.httpBody, let dict = try? JSONDecoder().decode([String: String].self, from: body) {
                print("\(log) - Parameters: \(dict)")
            } else {
                print(log)
            }
        case .success:
            print("\(log) - Success")
        case .failure(let error):
            print("\(log) - Failure: \(error)")
        }
    }

    private func isDebug() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
