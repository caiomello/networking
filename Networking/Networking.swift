//
//  Networking.swift
//  Networking
//
//  Created by Caio Mello on April 25, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public protocol NetworkingClientConfiguration {
	func networkingClientBaseURL() -> String
	func networkingClientDefaultParameters() -> [String: Any]?
	func networkingClientTimeoutInterval() -> TimeInterval
}

extension NetworkingClientConfiguration {
	public func networkingClientDefaultParameters() -> [String: Any]? {
		return nil
	}
	
	public func networkingClientTimeoutInterval() -> TimeInterval {
		return 30
	}
}

public protocol NetworkingClientDelegate {
	func networkingClientDidBeginRunningTasks()
	func networkingClientDidEndRunningTasks()
}

public enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

public class Networking {
	public static let client = Networking()
	
	public var configuration: NetworkingClientConfiguration?
	public var delegate: NetworkingClientDelegate?
	
	fileprivate var numberOfRunningTasks = 0
	
	private init() {}
}

// MARK: - Requests

extension Networking {
	@discardableResult public func request<T>(_ resource: Resource<T>, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTask? {
		do {
			let configuration = try resource.configuration()
			let request = try URLRequest(configuration: configuration)
			
			log(configuration: configuration, request: request, error: nil)
			
			let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
				do {
					if let connectionError = ConnectionError(response: response, error: error) { throw connectionError }
					
					let object = try resource.parse(data)
					
					DispatchQueue.main.async {
						self.hideNetworkActivityIndicator()
						completion(.success(object))
					}
				} catch {
					self.log(configuration: configuration, request: request, error: error as? NetworkingError)
					
					DispatchQueue.main.async {
						self.hideNetworkActivityIndicator()
						completion(.failure(error as! NetworkingError))
					}
				}
			})
			
			task.resume()
			
			return task
			
		} catch {
			log(error: error)
			
			DispatchQueue.main.async {
				self.hideNetworkActivityIndicator()
				completion(.failure(error as! NetworkingError))
			}
			
			return nil
		}
	}
}

// MARK: - Logging

extension Networking {
	fileprivate func log(configuration: ResourceConfiguration, request: URLRequest, error: NetworkingError?) {
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

extension Networking {
	fileprivate func showNetworkActivityIndicator() {
		delegate?.networkingClientDidBeginRunningTasks()
		numberOfRunningTasks += 1
	}
	
	fileprivate func hideNetworkActivityIndicator() {
		numberOfRunningTasks -= 1
		
		if numberOfRunningTasks == 0 {
			delegate?.networkingClientDidEndRunningTasks()
		}
	}
}
