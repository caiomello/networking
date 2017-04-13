//
//  ResponseError.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

enum ResponseError: ErrorType {
	case invalidAPIKey
	case notFound
	case invalidURL
	case filterFailed
	case rateLimitReached
	
	init?(code: Int) {
		switch code {
		case 100: self = .invalidAPIKey
		case 101: self = .notFound
		case 102: self = .invalidURL
		case 104: self = .filterFailed
		case 107: self = .rateLimitReached
		default: return nil
		}
	}
	
	var title: String {
		switch self {
		case .rateLimitReached: return "Too many requests right now"
		default: return GenericErrorTitle
		}
	}
	
	var message: String {
		switch self {
		case .rateLimitReached: return "Try again in a few moments"
		default: return GenericErrorMessage
		}
	}
	
	var technicalDescription: String {
		switch self {
		case .invalidAPIKey: return "Invalid API key"
		case .notFound: return "Not found"
		case .invalidURL: return "Invalid URL"
		case .filterFailed: return "Filter failed"
		case .rateLimitReached: return "Rate limit reached"
		}
	}
	
	var description: String {
		return "Response error: \(technicalDescription)"
	}
}
