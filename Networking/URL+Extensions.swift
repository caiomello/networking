//
//  URL+Extensions.swift
//  Networking
//
//  Created by Caio on 6/15/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

extension URL {
    init(string: String, method: HTTP.Method, parameters: [String: String]?) {
        let urlWithParameters: String = {
            if method == .get, let queryString = parameters?.queryString() {
                if string.contains("?") {
                    return string + "&" + queryString
                } else {
                    return string + "?" + queryString
                }
            }

            return string
        }()

        self.init(string: urlWithParameters.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
}

extension Dictionary {
    fileprivate func queryString() -> String {
        let fields = map({ "\($0.key)=\($0.value)" })
        return fields.joined(separator: "&")
    }
}
