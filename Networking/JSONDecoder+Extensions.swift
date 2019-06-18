//
//  JSONDecoder+Extensions.swift
//  Networking
//
//  Created by Caio on 6/18/19.
//  Copyright © 2019 Caio Mello. All rights reserved.
//

import Foundation

extension JSONDecoder {
    public convenience init(dateFormat: String) {
        self.init()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateDecodingStrategy = .formatted(dateFormatter)
    }
}
