//
//  Logger.swift
//  
//
//  Created by Caio Mello on 22.06.21.
//

import Foundation

enum LogType {
    case requestFired
    case success
    case failure(Error)
}

struct Logger {
    func log(endpoint: Endpoint, response: URLResponse? = nil, type: LogType) {
        let message: String = {
            let urlString = (try? endpoint.request.url?.absoluteString) ?? "INVALID URL"

            var components = ["[\(endpoint.method)]"]

            if let httpResponse = response as? HTTPURLResponse {
                components.append("[\(httpResponse.statusCode)]")
            }

            components.append("[\(urlString)]")

            return components.joined(separator: " ")
        }()

        switch type {
        case .requestFired:
            print("🚀 \(message)")
        case .success:
            print("✅ \(message)")
        case .failure(let error):
            print("⛔️ \(message) - \(error)")
        }
    }
}
