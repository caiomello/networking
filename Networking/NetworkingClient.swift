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

    init(session: URLSession = .shared,
         timeoutInterval: TimeInterval = 30,
         loggingEnabled: Bool = true) {

        self.session = session
        self.timeoutInterval = timeoutInterval
        self.loggingEnabled = loggingEnabled
    }
}

// MARK: - Requests

extension NetworkingClient {
    @discardableResult public func request<T: Decodable>(_ url: String,
                                                         method: HTTP.Method,
                                                         parameters: [String: String]? = nil,
                                                         headers: [String: String]? = nil,
                                                         completion: @escaping (Result<T, NetworkingError>) -> Void) -> URLSessionDataTask? {
        do {
            let request = try URLRequest(url: url,
                                         method: method,
                                         parameters: parameters,
                                         headers: headers,
                                         timeoutInterval: timeoutInterval)

            log(request: request, parameters: parameters)
			
			let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
				do {
					if let connectionError = NetworkingError(response: response, error: error) {
                        throw connectionError
                    }

                    guard let data = data else { throw NetworkingError.noData }

                    let object = try JSONDecoder().decode(T.self, from: data)

					completion(.success(object))
					
				} catch {
					self.log(request: request, parameters: parameters, error: error as? NetworkingError)
					
					completion(.failure(error as! NetworkingError))
				}
			})
			
			task.resume()
			
			return task
			
		} catch {
			log(error: error)
			
			completion(.failure(error as! NetworkingError))
			
			return nil
		}
	}

    
}

// MARK: - Logging

extension NetworkingClient {
    private func log(request: URLRequest, parameters: [String: String]?, error: NetworkingError? = nil) {
		guard loggingEnabled else { return }
		
		let log = "[\(request.httpMethod!)] \(request.url!.absoluteString)"
		
		if let error = error {
			print(log + " - " + "\(error)")
		} else if let parameters = parameters {
			print(log + " " + "\(parameters)")
		} else {
			print(log)
		}
	}
	
	private func log(error: Error) {
		guard loggingEnabled else { return }
		print(error)
	}
}
