//
//  Post.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation
@testable import Networking

struct Post {
	let identifier: Int
	let title: String
	let body: String
	
	init(dictionary: [String: Any]) throws {
		guard let identifier = dictionary["id"] as? Int else { throw ParsingError.failed(description: "Post - identifier") }
		guard let title = dictionary["title"] as? String else { throw ParsingError.failed(description: "Post - title") }
		guard let body = dictionary["body"] as? String else { throw ParsingError.failed(description: "Post - body") }
		
		self.identifier = identifier
		self.title = title
		self.body = body
	}
}

// MARK: - Description

extension Post: CustomStringConvertible {
	var description: String {
		return "\nPost:\nIdentifier: \(identifier)\nTitle: \(title)\nBody: \(body)\n"
	}
}

// MARK: - Resources

extension Post {
	struct resource {
		static func identifier(_ identifier: Int) -> Resource<Post> {
			return Resource<Post>(configuration: { () -> ResourceConfiguration in
				let path = "/posts/" + "\(identifier)"
				
				return ResourceConfiguration(method: .get, path: path, parameters: nil, headerFields: nil)
				
			}, parsing: { (object) -> Post? in
				guard let dictionary = object as? [String: Any] else { throw ParsingError.failed(description: "Post - dictionary") }
				return try Post(dictionary: dictionary)
			})
		}
	}
}
