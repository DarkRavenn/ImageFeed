//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 29.08.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let thumb: String
    let full: String
}
