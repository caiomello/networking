//
//  ConnectionError.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public enum ConnectionError: NetworkingError {
	case unknown
	case noInternetConnection
	case timedOut
	case badRequest
	case unauthorized
	case forbidden
	case methodNotAllowed
	case conflict
	case notFound
	case serverError
	
	public var message: String {
		switch self {
		case .noInternetConnection: return "No internet connection"
		case .timedOut: return "The request took too long"
		default: return GenericErrorMessage
		}
	}
	
	public var technicalDescription: String {
		switch self {
		case .noInternetConnection: return "No internet connection"
		case .timedOut: return "Timed out"
		case .badRequest: return "Bad request"
		case .unauthorized: return "Unauthorized"
		case .forbidden: return "Forbidden"
		case .notFound: return "Not Found"
		case .methodNotAllowed: return "Method not allowed"
		case .conflict: return "Conflict"
		case .serverError: return "Server error"
		default: return "Unknown"
		}
	}
	
	public var description: String {
		return "Connection error: \(technicalDescription)"
	}
	
	init?(response: URLResponse?, error: Error?) {
		guard let code: Int = {
			if let error = error as NSError? {
				return error.code
			} else if let response = response as? HTTPURLResponse {
				return response.statusCode
			} else {
				return nil
			}
			}() else { return nil }
		
		if case 200...299 = code {
			return nil
		}
		
		self.init(code: code)
	}
	
	private init(code: Int) {
		switch code {
		case 0, -1009: self = .noInternetConnection
		case -1001: self = .timedOut
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
