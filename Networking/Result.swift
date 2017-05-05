//
//  Result.swift
//  Networking
//
//  Created by Caio Mello on May 5, 2017.
//  Copyright © 2017 Caio Mello. All rights reserved.
//

import Foundation

public enum Result<T> {
	case success(T)
	case failure(NetworkingError)
}
