//
//  SnakeCaseJSONDecoder.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 17.08.2024.
//

import Foundation

final class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
