//
//  DetailNewsController.swift
//

import UIKit
import WebKit

class DetailNewsController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    weak var coordinator: DetailNewsCoordinatorProtocol?
    var urlString: String
    var webView = WKWebView()
    
    init(urlString: String) {
        self.urlString = urlString
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(exitWebview))
        navigationItem.leftBarButtonItem = backButton
        
        let url = URL(string: urlString)
        let myRequest = URLRequest(url: url!)
        
        view = webView
        
        webView.load(myRequest)
    }
    
    @objc private func exitWebview() {
        coordinator?.backVC()
    }
}
