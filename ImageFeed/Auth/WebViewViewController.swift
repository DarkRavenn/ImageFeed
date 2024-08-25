//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Dugaev on 04.07.2024.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    weak var delegate: WebViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuthView()
        webView.navigationDelegate = self
        updateProgress()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
        options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             }
        )
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            print("urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) = nil")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("url = urlComponents.url = nil")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let code = code(from: navigationAction) {
             delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
          } else {
                decisionHandler(.allow)
          }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
