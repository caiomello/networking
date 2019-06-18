//
//  ExtensionTests.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import XCTest
@testable import Networking

class ExtensionTests: XCTestCase {
	var client: NetworkingClient!
	
	override func setUp() {
		super.setUp()
		
		client = NetworkingClient()
	}
	
	override func tearDown() {
		client = nil
		
		super.tearDown()
	}
}

// MARK: - URL

extension ExtensionTests {
	func testURLInit() {
        let url = URL(string: "https://jsonplaceholder.typicode.com", parameters: ["apikey": "1234", "page": "1", "date": "2017-04-13"])

		XCTAssertEqual(url.absoluteString, "https://jsonplaceholder.typicode.com?apikey=1234&page=1&date=2017-04-13")
	}
}
