//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 16.07.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreen"

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        addSplashScreenLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if oauth2TokenStorage.token != nil {
            fetchProfile()
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: .main)
            let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            
            guard let authViewController else { return }
            
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            
            present(authViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: - Overrides Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        fetchProfile()
    }
    
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case.success(let profile):
                fetchProfileImage(profile.username)
                self.switchToTabBarController()
            case.failure:
                break
            }
        }
    }
    
    private func fetchProfileImage(_ username: String) {
        profileImageService.fetchProfileImageURL(username: username) { result in
            switch result {
            case.success:
                print(result)
            case.failure:
                break
            }
        }
    }
    
    private func addSplashScreenLogo() {
        let splashScreenLogo = UIImage(named: "splash_screen_logo")
        let imageView = UIImageView(image: splashScreenLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}
