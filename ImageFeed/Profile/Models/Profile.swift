//
//  Profile.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 17.08.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(firstName: String, lastName: String, username: String, bio: String) {
        self.username = username
        self.name = "\(firstName) \(lastName)"
        self.loginName = "@\(username)"
        self.bio = bio
    }
}
