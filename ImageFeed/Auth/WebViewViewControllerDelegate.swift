//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 14.07.2024.
//

import Foundation

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
