//
//  AuthorizeViewController.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import UIKit
import WebKit
import KeychainAccess
import APIKit
import RxSwift

class AuthorizeViewController: UIViewController {
    
    @IBOutlet fileprivate weak var webViewContainer: UIView!
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var webView: WKWebView?
    fileprivate var presenter: AuthorizePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        
        presenter = AuthorizePresenter(useCase: AuthorizeUseCaseImpl())
        setupBindings()
    }
    
    private func setupWebView() {
        // プライベートモード的な動きをする WKWebView をインスタンス化。
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        webView = WKWebView(frame: webViewContainer.bounds, configuration: configuration)
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView?.navigationDelegate = self
        
        if let webView = webView {
            webViewContainer.addSubview(webView)
        }
    }
    
    private func setupBindings() {
        presenter.retrieveDidSuccessMessage
            .asSignal()
            .emit(onNext: { [unowned self] _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        presenter.retrieveDidFailMessage
            .asSignal()
            .emit(onNext: { [unowned self] _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let parameters = [
            "client_id": Constants.ClientId,
            "response_type": "code",
            "redirect_uri": Constants.RedirectUri,
            "scope": "read write follow",
            ]
        let query = URLEncodedSerialization.string(from: parameters)
        guard let url = URL(string: "\(Constants.MastodonHost)/oauth/authorize?\(query)") else { return }
        self.webView?.load(URLRequest(url: url))
    }
}

extension AuthorizeViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let query = "document.querySelector('.oauth-code').value"
        webView.evaluateJavaScript(query) { [weak self] html, error in
            guard let authorizationCode = html as? String else { return }
            
            self?.presenter.retrieveAccessToken(authorizationCode: authorizationCode)
        }
    }
}
