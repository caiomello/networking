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
	let url: String
	let parameters: Any?
	let headerFields: [String: String]?
}

public struct Resource<T> {
	let configuration: () throws -> ResourceConfiguration
	let parse: (Data?) throws -> T?
	
	init(configuration: @escaping () throws -> ResourceConfiguration, parseJSON: @escaping (_ object: Any?) throws -> T?) {
		self.configuration = configuration
		self.parse = { data in
			guard let data = data, data.count > 0 else { throw ParsingError.noData }
			
			let json = try? JSONSerialization.jsonObject(with: data, options: [])
			
			guard let object = try json.flatMap(parseJSON) else { throw ParsingError.invalidJSON }
			return object
		}
	}
}
