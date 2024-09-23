//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Aleksandr Dugaev on 23.09.2024.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var didUpdateAvatarCalled: Bool = false

    var view: (any ImageFeed.ProfileViewViewControllerProtocol)?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateAvatar() {
        didUpdateAvatarCalled = true
    }

    func logout() {}
}
