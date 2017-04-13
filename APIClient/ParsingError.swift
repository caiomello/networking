//
//  ParsingError.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

enum ParsingError: ErrorType {
	case noData
	case invalidJSON
	case failed(description: String)
	
	var title: String {
		return GenericErrorTitle
	}
	
	var message: String {
		return GenericErrorMessage
	}
	
	var technicalDescription: String {
		switch self {
		case .noData: return "No data"
		case .invalidJSON: return "Invalid JSON"
		case let .failed(description): return description
		}
	}
	
	var description: String {
		return "Parsing error: \(technicalDescription)"
	}
}
