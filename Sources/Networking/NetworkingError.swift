//
//  NetworkingError.swift
//  
//
//  Created by Caio Mello on 22.06.21.
//

import Foundation

enum NetworkingError: Error {
    case unknown
    case invalidURL
    case noInternetConnection
    case timedOut
    case badRequest
    case unauthorized
    case forbidden
    case methodNotAllowed
    case conflict
    case notFound
    case serverError

    init?(statusCode: Int) {
        switch statusCode {
        case 0, -1009: self = .noInternetConnection
        case -1001: self = .timedOut
        case 200...299: return nil
        case 400, 422: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 404: self = .notFound
        case 405: self = .methodNotAllowed
        case 409: self = .conflict
        case 500: self = .serverError
        default: self = .unknown
        }
    }
}
