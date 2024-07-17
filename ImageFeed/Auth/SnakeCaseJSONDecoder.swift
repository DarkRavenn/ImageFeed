//
//  JSONDecoder+Extension.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 18.07.2024.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
