//
//  Constants.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 12.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "unYgt06Msl7qyRJIf1EyMvN4ImZx3OZ9HPNMIYYl9pE"
    static let secretKey = "WcLrlv0NgzzyLOpVBPQuhZ4tAi7tEblaCmWfFh7j_Qg"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = "https://unsplash.com"
    static let defaultBaseApiURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

enum UnsplashApiPath {
    static let me = "/me"
    static let users = "/users"
    static let photos = "/photos"
}
