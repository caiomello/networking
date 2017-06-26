//
//  ClientError.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

enum ClientError: NetworkingError {
	case noConfiguration
	case invalidURL
	
	var technicalDescription: String {
		switch self {
		case .noConfiguration: return "Client not configured"
		case .invalidURL: return "Invalid URL"
		}
	}
	
	var description: String {
		return "Client error: \(technicalDescription)"
	}
}
