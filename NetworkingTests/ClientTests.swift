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
	override func setUp() {
		super.setUp()
		
		Networking.client.configuration = self
	}
}

// MARK: - Tests

extension APIClientTests {
	func testRequest() {
		let expectation = self.expectation(description: "GET /posts/1")
		
		let task = Networking.client.request(Post.resource.identifier(1)) { (result) in
			switch result {
			case .success(let object):
				print(object)
			case .failure(let error):
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

// MARK: - APIClient

extension APIClientTests: NetworkingClientConfiguration {
	func baseURL() -> String {
		return "https://jsonplaceholder.typicode.com"
	}
	
	func defaultParameters() -> [String : Any]? {
		return nil
	}
	
	func timeoutInterval() -> TimeInterval {
		return 10
	}
}
