//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 15.09.2024.
//

import Foundation
import WebKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() { }
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    func logout() {
        cleanCookies()
        profileService.cleanProfile()
        profileImageService.cleanavatarURL()
        imagesListService.cleanPhotos()
        cleanImagesCache()
        cleanAuthToken()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { record in
            record.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
        
    private func cleanImagesCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    private func cleanAuthToken() {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
    }    
}
