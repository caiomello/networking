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
	var configuration: ResourceConfiguration!
	
	override func setUp() {
		super.setUp()
		
		client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com", defaultParameters: ["apikey": "1234"], timeoutInterval: 30, loggingEnabled: true)
		configuration = ResourceConfiguration(method: .get, path: "", parameters: ["page": "1", "date": "2017-04-13"], headerFields: ["key": "value"])
	}
	
	override func tearDown() {
		client = nil
		configuration = nil
		
		super.tearDown()
	}
}

// MARK: - URLRequest

extension ExtensionTests {
	func testMethod() {
		XCTAssertEqual(configuration?.method, .get)
	}
	
	func testHeaderFields() {
		guard let fields = configuration?.headerFields else { XCTFail(); return }
		
		XCTAssertEqual(fields, ["key": "value"])
	}
}

// MARK: - URL

extension ExtensionTests {
	func testURLInit() {
		guard let url = URL(baseURL: client.baseURL, defaultParameters: client.defaultParameters, configuration: configuration) else { XCTFail(); return }
		XCTAssertEqual(url.absoluteString, "https://jsonplaceholder.typicode.com?page=1&date=2017-04-13&apikey=1234")
	}
}
