//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 21.05.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

public protocol ProfileViewViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func addProfileImageView()
    func addUserNameLabel(_ text: String)
    func addUserIdLabel(_ text: String)
    func addUserTextLabel(_ text: String)
    func addExitButton()
    func updateAvatar(image: URL)
}

final class ProfileViewController: UIViewController & ProfileViewViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    
    // MARK: - Private Properties
    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var exitButton: UIButton  = {
        let exitButton = UIButton(type: .custom)
        exitButton.setImage(UIImage(named: "Exit_button"), for: .normal)
        exitButton.addTarget(ProfileViewController.self, action: #selector(exitButtonTapped), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private var profileDetails: Profile?
    private var profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    
    
    // MARK: - View Life Cycles    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypBlack
        
        presenter?.viewDidLoad()
        
        // Получаем фото пользователя
        profileImageServiceObserver = NotificationCenter.default.addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.didUpdateAvatar()
            }
        presenter?.didUpdateAvatar()
    }
        
    // MARK: - Private Methods
    func updateAvatar(image: URL) {
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: image,
                                     placeholder: UIImage(named: "placeholder"))
    }

    func addProfileImageView() {
        view.addSubview(profileImageView)
        
        profileImageView.layer.cornerRadius = 35
        profileImageView.layer.masksToBounds = true
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func addUserNameLabel(_ text: String) {
        view.addSubview(nameLabel)

        nameLabel.text = text
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    func addUserIdLabel(_ text: String) {
            view.addSubview(idLabel)

            idLabel.text = text
            idLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        }
    
    func addUserTextLabel(_ text: String) {
            view.addSubview(textLabel)

            textLabel.text = text
            textLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor).isActive = true
            textLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8).isActive = true
        }
    
    func addExitButton() {
            view.addSubview(exitButton)

            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
            exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
            exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    
    @objc private func exitButtonTapped() {
        let alertController = UIAlertController(title: "Пока, пока!",
                                                message: "Уверены, что хотите выйти",
                                                preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.logout()
            
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = SplashViewController()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = cancelAction
        
        present(alertController, animated: true, completion: nil)
    }
}
