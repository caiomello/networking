//
//  ExtensionTests.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import XCTest
@testable import APIClient

class ExtensionTests: XCTestCase {
	var configuration: ResourceConfiguration?
	
	override func setUp() {
		super.setUp()
		
		configuration = ResourceConfiguration(method: .get, url: "https://jsonplaceholder.typicode.com", parameters: ["page": "1", "date": "2017-04-13"], headerFields: ["Key": "Value"])
	}
	
	override func tearDown() {
		configuration = nil
		super.tearDown()
	}
}

// MARK: - URLRequest

extension ExtensionTests {
	func testMethod() {
		XCTAssertEqual(configuration?.method, .get, "HTTP method should be 'GET'")
	}
	
	func testHeaderFields() {
		guard let fields = configuration?.headerFields else { XCTFail(); return }
		XCTAssertEqual(fields, ["Key": "Value"], "Header fields should be '[Key: Value]'")
	}
}

// MARK: - URL

extension ExtensionTests {
	func testURLInit() {
		guard let configuration = configuration else { XCTFail(); return }
		guard let url = URL(configuration: configuration)?.absoluteString else { XCTFail(); return }
		
		XCTAssertEqual(url, "https://jsonplaceholder.typicode.com?page=1&date=2017-04-13", "URL should be 'https://jsonplaceholder.typicode.com?page=1&date=2017-04-13'")
	}
}
