//
//  URLRequest+Extensions.swift
//  Networking
//
//  Created by Caio on 6/15/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

extension URLRequest {
    init(url: String, method: HTTP.Method, parameters: [String: String]?, headers: [String: String]?, timeoutInterval: TimeInterval) {
        let url = URL(string: url, method: method, parameters: parameters)

        self.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)

        httpMethod = method.rawValue
        allHTTPHeaderFields = headers

        if method != .get, let parameters = parameters {
            httpBody = try? JSONEncoder().encode(parameters)
        }
    }
}
