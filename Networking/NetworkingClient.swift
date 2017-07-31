//
//  NetworkingClient.swift
//  Networking
//
//  Created by Caio Mello on April 25, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

public struct NetworkingClient {
	let baseURL: String
	let defaultParameters: [String: Any]?
	let timeoutInterval: TimeInterval
	let loggingEnabled: Bool
	
	public init(baseURL: String, defaultParameters: [String: Any]?, timeoutInterval: TimeInterval, loggingEnabled: Bool) {
		self.baseURL = baseURL
		self.defaultParameters = defaultParameters
		self.timeoutInterval = timeoutInterval
		self.loggingEnabled = loggingEnabled
	}
}

// MARK: - Requests

extension NetworkingClient {
	@discardableResult public func request<T>(_ resource: Resource<T>, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask? {
		do {
			let configuration = try resource.configuration()
			let request = try URLRequest(client: self, configuration: configuration)
			
			log(configuration: configuration, request: request, error: nil)
			
			let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
				do {
					if let connectionError = ConnectionError(response: response, error: error) { throw connectionError }
					
					let object = try resource.parse(data)
					
					completion(.success(object))
					
				} catch {
					self.log(configuration: configuration, request: request, error: error as? NetworkingError)
					
					completion(.failure(error as! NetworkingError, response as? HTTPURLResponse))
				}
			})
			
			task.resume()
			
			return task
			
		} catch {
			log(error: error)
			
			completion(.failure(error as! NetworkingError, nil))
			
			return nil
		}
	}
}

// MARK: - Logging

extension NetworkingClient {
	private func log(configuration: ResourceConfiguration, request: URLRequest, error: NetworkingError?) {
		guard loggingEnabled else { return }
		
		let log = "[\(configuration.method.rawValue)] \(request.url!.absoluteString)"
		
		if let error = error {
			print(log + " - " + "\(error)")
		} else if let parameters = configuration.parameters as? String {
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
