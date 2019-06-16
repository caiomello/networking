//
//  Post.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

struct Post: Decodable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case body
    }

	let identifier: Int
	let title: String
	let body: String
}
