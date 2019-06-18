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
    let decoder: JSONDecoder
	let timeoutInterval: TimeInterval
	let loggingEnabled: Bool

    public init(session: URLSession = .shared,
                decoder: JSONDecoder = JSONDecoder(),
                timeoutInterval: TimeInterval = 30,
                loggingEnabled: Bool = true) {

        self.session = session
        self.decoder = decoder
        self.timeoutInterval = timeoutInterval
        self.loggingEnabled = loggingEnabled
    }
}

// MARK: - Requests

extension NetworkingClient {
    @discardableResult public func get<T: Decodable>(_ url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
        let urlRequest = URLRequest(url: url, method: .get, parameters: parameters, headers: headers, timeoutInterval: timeoutInterval)
        return request(urlRequest, parameters: parameters, headers: headers, completion: completion)
    }

    @discardableResult public func post<T: Decodable>(_ url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
        let urlRequest = URLRequest(url: url, method: .post, parameters: parameters, headers: headers, timeoutInterval: timeoutInterval)
        return request(urlRequest, parameters: parameters, headers: headers, completion: completion)
    }

    @discardableResult public func put<T: Decodable>(_ url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
        let urlRequest = URLRequest(url: url, method: .put, parameters: parameters, headers: headers, timeoutInterval: timeoutInterval)
        return request(urlRequest, parameters: parameters, headers: headers, completion: completion)
    }

    @discardableResult public func delete<T: Decodable>(_ url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
        let urlRequest = URLRequest(url: url, method: .delete, parameters: parameters, headers: headers, timeoutInterval: timeoutInterval)
        return request(urlRequest, parameters: parameters, headers: headers, completion: completion)
    }

    @discardableResult private func request<T: Decodable>(_ request: URLRequest, parameters: [String: String]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
        log(request: request, type: .requestFired)

        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                if let connectionError = NetworkingError(response: response, error: error) { throw connectionError }

                guard let data = data else { throw NetworkingError.noData }

                let object = try self.decoder.decode(T.self, from: data)
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
