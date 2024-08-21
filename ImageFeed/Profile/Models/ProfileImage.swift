//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 21.08.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
}

struct ProfileImage: Codable {
    let small: String
}
