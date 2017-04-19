//
//  ParsingError.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public enum ParsingError: NetworkingError {
	case noData
	case invalidJSON
	case failed(description: String)
	
	public var title: String {
		return GenericErrorTitle
	}
	
	public var message: String {
		return GenericErrorMessage
	}
	
	public var technicalDescription: String {
		switch self {
		case .noData: return "No data"
		case .invalidJSON: return "Invalid JSON"
		case let .failed(description): return description
		}
	}
	
	public var description: String {
		return "Parsing error: \(technicalDescription)"
	}
}
