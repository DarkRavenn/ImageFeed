//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 04.07.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
