//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 04.07.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowSingleImage"
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button") // 1
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button") // 2
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // 3
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black") // 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
}
