//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 15.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "accessToken"

    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: tokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
