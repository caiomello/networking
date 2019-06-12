//
//  APIClientTests.swift
//  APIClientTests
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import XCTest
@testable import Networking

class APIClientTests: XCTestCase {
	var client: NetworkingClient!
	var configuration: ResourceConfiguration!
	
	override func setUp() {
		super.setUp()
		
		client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com", defaultParameters: nil, timeoutInterval: 30, loggingEnabled: true)
	}
	
	override func tearDown() {
		client = nil
		
		super.tearDown()
	}
}

// MARK: - Tests

extension APIClientTests {
	func testRequest() {
		let expectation = self.expectation(description: "GET /posts/1")
		
		let task = client.request(Post.resource.identifier(1)) { (result) in
			switch result {
			case .success(let object):
				print(object)
			case .failure(let error, _):
				print(error)
			}
			
			expectation.fulfill()
		}
		
		XCTAssertEqual(task?.originalRequest?.url?.absoluteString, "https://jsonplaceholder.typicode.com/posts/1")
		
		waitForExpectations(timeout: task!.originalRequest!.timeoutInterval) { (error) in
			if let error = error {
				print(error)
			}
			
			task?.cancel()
		}
	}
}
