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
	var configuration: ResourceConfiguration?
	
	override func setUp() {
		super.setUp()
		
		configuration = ResourceConfiguration(method: .get, path: "", parameters: ["page": "1", "date": "2017-04-13"], headerFields: ["key": "value"])
		
		Networking.client.configuration = self
	}
	
	override func tearDown() {
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
		guard let configuration = configuration else { XCTFail(); return }
		guard let url = URL(configuration: configuration)?.absoluteString else { XCTFail(); return }
		
		XCTAssertEqual(url, "https://jsonplaceholder.typicode.com?page=1&date=2017-04-13&apikey=1234")
	}
}

// MARK: - APIClient

extension ExtensionTests: NetworkingClientConfiguration {
	func baseURL() -> String {
		return "https://jsonplaceholder.typicode.com"
	}
	
	func defaultParameters() -> [String : Any]? {
		return ["apikey": "1234"]
	}
	
	func timeoutInterval() -> TimeInterval {
		return 10
	}
}
