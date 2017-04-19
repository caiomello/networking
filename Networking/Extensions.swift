//
//  Extensions.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

// MARK: - URLRequest

extension URLRequest {
	init(configuration: ResourceConfiguration) throws {
		guard let url = URL(configuration: configuration) else { throw ClientError.invalidURL }
		guard let timeoutInterval = APIClient.shared.configuration?.timeoutInterval() else { throw ClientError.noConfiguration }
		
		self.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
		self.httpMethod = configuration.method.rawValue
		self.allHTTPHeaderFields = configuration.headerFields
		self.httpBody = Data(configuration: configuration)
	}
}

// MARK: - URL

extension URL {
	init?(configuration: ResourceConfiguration) {
		func parameterString(withDictionary dictionary: [String: Any]) -> String {
			let parameters = dictionary.keys.flatMap({ (key) -> String? in
				guard let value = dictionary[key] else { return nil }
				return "\(key)=\(value)"
			})
			
			return parameters.joined(separator: "&")
		}
		
		let path: String = {
			if configuration.method == .get {
				if let dictionary = configuration.parameters as? [String: Any] {
					return configuration.path + "?" + parameterString(withDictionary: dictionary)
					
				} else if let string = configuration.parameters as? String {
					return string
				}
			}
			
			return configuration.path
		}()
		
		guard let baseURL = APIClient.shared.configuration?.baseURL() else { return nil }
		
		let url: String = {
			let parameters: String? = {
				guard let defaultParameters = APIClient.shared.configuration?.defaultParameters() else { return nil }
				return parameterString(withDictionary: defaultParameters)
			}()
			
			if let parameters = parameters {
				if path.contains("?") {
					return baseURL + path + "&" + parameters
				} else {
					return baseURL + path + "?" + parameters
				}
			}
			
			return baseURL + path
		}()
		
		guard let string = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
		self.init(string: string)
	}
}

// MARK: - Data

extension Data {
	init?(configuration: ResourceConfiguration) {
		guard let parameters = configuration.parameters, configuration.method != .get else { return nil }
		guard let string = parameters as? String else { return nil }
		guard let data = string.data(using: String.Encoding.utf8) else { return nil }
		
		self.init()
		self.append(data)
	}
}
