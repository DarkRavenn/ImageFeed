//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 15.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "accessToken"

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
//            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
                guard isSuccess else {
                    print("Ошибка сохранения токена")
                    return
                }
//                UserDefaults.standard.set(token, forKey: tokenKey)
            } else {
                let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: tokenKey)
//                UserDefaults.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
