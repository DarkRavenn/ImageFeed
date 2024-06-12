//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 21.05.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAvatarImageView()
        addNameLabel()
        addLoginNameLabel()
        addDescriptionLabel()
        addLogoutButton()
    }
    
    private func addAvatarImageView() {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.avatarImageView = imageView
    }
    
    private func addNameLabel() {
        guard let imageView = avatarImageView else { return }
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        self.nameLabel = label
    }
    
    private func addLoginNameLabel() {
        guard let label1 = nameLabel else { return }
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        self.loginNameLabel = label
        label.leadingAnchor.constraint(equalTo: label1.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addDescriptionLabel() {
        guard let label2 = loginNameLabel else { return }
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: label2.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 8).isActive = true
        self.descriptionLabel = label
    }
    
    private func addLogoutButton() {
        guard let imageView = avatarImageView else { return }
        let button = UIButton.systemButton(
            with: UIImage(named: "Exit_button")!,
            target: self,
            action: #selector(Self.didTapExitButton)
        )
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapExitButton() {
        nameLabel?.removeFromSuperview()
        nameLabel = nil
        
        loginNameLabel?.removeFromSuperview()
        loginNameLabel = nil
        
        descriptionLabel?.removeFromSuperview()
        descriptionLabel = nil
        
        let profileImage = UIImage(named: "avatar_no_data")
        avatarImageView?.image = profileImage
    }
}
