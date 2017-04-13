//
//  ErrorType.swift
//  APIClient
//
//  Created by Caio Mello on April 13, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public let GenericErrorTitle = "Error"
public let GenericErrorMessage = "Please try again"

public protocol ErrorType: Error, CustomStringConvertible {
	var title: String { get }
	var message: String { get }
	var technicalDescription: String { get }
}
