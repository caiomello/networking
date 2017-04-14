//
//  APIClient.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public protocol APIClientConfiguration {
	func baseURL() -> String
	func defaultParameters() -> [String: Any]?
	func timeoutInterval() -> TimeInterval
}

public protocol APIClientDelegate {
	func didBeginRunningTasks()
	func didEndRunningTasks()
}

public enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

public class APIClient {
	public static let shared = APIClient()
	
	public var configuration: APIClientConfiguration?
	public var delegate: APIClientDelegate?
	
	fileprivate var numberOfRunningTasks = 0
}

// MARK: - Requests

extension APIClient {
	@discardableResult public func request<T>(_ resource: Resource<T>, completion: @escaping (T?, _ error: ErrorType?) -> Void) -> URLSessionDataTask? {
		showNetworkActivityIndicator()
		
		do {
			let configuration = try resource.configuration()
			let request = try URLRequest(configuration: configuration)
			
			log(configuration: configuration, request: request, error: nil)
			
			let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
				DispatchQueue.main.async {
					self.hideNetworkActivityIndicator()
					
					do {
						if let connectionError = ConnectionError(response: response, error: error) { throw connectionError }
						completion(try resource.parse(data), nil)
					} catch {
						self.log(configuration: configuration, request: request, error: error as? ErrorType)
						completion(nil, error as? ErrorType)
					}
				}
			})
			
			task.resume()
			
			return task
			
		} catch {
			hideNetworkActivityIndicator()
			log(error: error)
			completion(nil, error as? ErrorType)
			return nil
		}
	}
}

// MARK: - Logging

extension APIClient {
	fileprivate func log(configuration: ResourceConfiguration, request: URLRequest, error: ErrorType?) {
		let log = "[\(configuration.method.rawValue)] \(request.url!.absoluteString)"
		
		if let error = error {
			print(log + " - " + "\(error)")
		} else if let parameters = configuration.parameters as? String {
			print(log + " " + "\(parameters)")
		} else {
			print(log)
		}
	}
	
	fileprivate func log(error: Error) {
		print(error)
	}
}

// MARK: - Network Activity Indicator

extension APIClient {
	fileprivate func showNetworkActivityIndicator() {
		delegate?.didBeginRunningTasks()
		numberOfRunningTasks += 1
	}
	
	fileprivate func hideNetworkActivityIndicator() {
		numberOfRunningTasks -= 1
		
		if numberOfRunningTasks == 0 {
			delegate?.didEndRunningTasks()
		}
	}
}
