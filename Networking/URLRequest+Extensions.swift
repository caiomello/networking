//
//  URLRequest+Extensions.swift
//  Networking
//
//  Created by Caio on 6/15/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

extension URLRequest {
    init(url: String, parameters: [String: String]?, headers: [String: String]?, timeoutInterval: TimeInterval) {
        let url = URL(string: url, parameters: parameters)

        self.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)

        httpMethod = "GET"
        allHTTPHeaderFields = headers
    }
}
