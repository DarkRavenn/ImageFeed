//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 17.08.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}
