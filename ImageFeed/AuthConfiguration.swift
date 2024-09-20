//
//  Constants.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 12.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "4GL81kLaodobhpvBsNvQN6oHVx6Oo9q9pP7e7RWca-s"
    static let secretKey = "A1JPsL4Kh-WN5PScMjrMlfpZ-5ODYtVb53idcQEKLXQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

enum UnsplashApiPath {
    static let me = "/me"
    static let users = "/users"
    static let photos = "/photos"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    static var unsplash24: AuthConfiguration {
        return AuthConfiguration(accessKey: "8B58LKmSw2rbXEVy_gLZUbp1NfgulpJxGo_Ubyxftc0",
                                 secretKey: "OB9Ur0oZ34WivwDEUsk3XyAskJPB98ePshqnMf9BDH0",
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    static var unsplash12: AuthConfiguration {
        return AuthConfiguration(accessKey: "unYgt06Msl7qyRJIf1EyMvN4ImZx3OZ9HPNMIYYl9pE",
                                 secretKey: "WcLrlv0NgzzyLOpVBPQuhZ4tAi7tEblaCmWfFh7j_Qg",
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
}
