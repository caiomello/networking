//
//  APIClientTests.swift
//  APIClientTests
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import XCTest
@testable import APIClient

class APIClientTests: XCTestCase {
	override func setUp() {
		super.setUp()
		
		APIClient.shared.configuration = self
	}
}

// MARK: - Tests

extension APIClientTests {
	func testRequest() {
		let expectation = self.expectation(description: "GET /posts/1")
		
		let task = APIClient.shared.request(Post.resource.identifier(1)) { (post, error) in
			if let error = error {
				print(error)
			} else if let post = post {
				print(post)
			}
			
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: task!.originalRequest!.timeoutInterval) { (error) in
			if let error = error {
				print(error)
			}
			
			task?.cancel()
		}
	}
}

// MARK: - APIClient

extension APIClientTests: APIClientConfiguration {
	func baseURL() -> String {
		return "https://jsonplaceholder.typicode.com"
	}
	
	func timeoutInterval() -> TimeInterval {
		return 10
	}
}
