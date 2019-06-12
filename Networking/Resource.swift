//
//  Resource.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public struct ResourceConfiguration {
	let method: HTTPMethod
	let path: String
	let parameters: Any?
	let headerFields: [String: String]?
	
	public init(method: HTTPMethod, path: String) {
		self.init(method: method, path: path, parameters: nil, headerFields: nil)
	}
	
	public init(method: HTTPMethod, path: String, parameters: Any) {
		self.init(method: method, path: path, parameters: parameters, headerFields: nil)
	}
	
	public init(method: HTTPMethod, path: String, headerFields: [String: String]) {
		self.init(method: method, path: path, parameters: nil, headerFields: headerFields)
	}
	
	public init(method: HTTPMethod, path: String, parameters: Any?, headerFields: [String: String]?) {
		self.method = method
		self.path = path
		self.parameters = parameters
		self.headerFields = headerFields
	}
}

public struct Resource<T> {
	let configuration: () throws -> ResourceConfiguration
	let parse: (Data?) throws -> T
	
	public init(configuration: @escaping () throws -> ResourceConfiguration, parsing: @escaping (_ object: Any?) throws -> T) {
		self.configuration = configuration
		self.parse = { data in
			guard let data = data, data.count > 0 else { throw ParsingError.noData }
			
			let json = try? JSONSerialization.jsonObject(with: data, options: [])
			
			guard let object = try json.flatMap(parsing) else { throw ParsingError.invalidJSON }
			return object
		}
	}
}
