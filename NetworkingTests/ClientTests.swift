//
//  ClientTests.swift
//  ClientTests
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import XCTest
@testable import Networking

class ClientTests: XCTestCase {
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

// MARK: - Tests

extension ClientTests {
	func testRequest() {
		let expectation = self.expectation(description: "GET /posts/1")

        let task = client.request("https://jsonplaceholder.typicode.com/posts/1") { (result: Result<Post, NetworkingError>) in
			switch result {
			case .success(let object):
				print(object)
			case .failure(let error):
				XCTFail(error.technicalDescription)
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
