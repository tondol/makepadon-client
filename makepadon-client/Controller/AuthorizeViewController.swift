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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let parameters = [
            "client_id": Constants.ClientId,
            "response_type": "code",
            "redirect_uri": Constants.RedirectUri,
            "scope": "read write follow",
            ]
        let queryString = URLEncodedSerialization.string(from: parameters)
        let urlString = "\(Constants.MastodonHost)/oauth/authorize?\(queryString)"
        webView?.load(URLRequest(url: URL(string: urlString)!))
    }
}

extension AuthorizeViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 他にいいやり方があるなら知りたい...
        let queryCode = "document.querySelector('.oauth-code').value"
        webView.evaluateJavaScript(queryCode) { [weak self] html, error in
            guard let authorizationCode = html as? String else { return }
            
            self?.retrieveAccessToken(authorizationCode: authorizationCode)
        }
    }
    
    private func retrieveAccessToken(authorizationCode: String) {
        // とりあえず ViewController に書いちゃう。
        Session.rx_sendRequest(request: AuthorizeRequest(authorizationCode: authorizationCode))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result -> Void in
                MyKeychain.shared[MyKeychain.Keys.AccessToken] = result.accessToken
                
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }, onError: { [weak self] error -> Void in
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
}
