//
//  OAuthTokenResponseBodyModel.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 15.07.2024.
//

import Foundation

struct AccessTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
