//
//  WelcomeViewController.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/04/15.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import UIKit
import APIKit
import RxSwift

class WelcomeViewController: UIViewController {
    
    @IBOutlet fileprivate weak var button: UIButton!
    
    fileprivate let bag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ログイン状態を確認する。
        Session.rx_sendRequest(request: VerifyCredentialsRequest())
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] account in
                let vc = ListViewController.instantiateFromStoryboard(storyboard: "Main")
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
    
    @IBAction func didTapButton(sender: UIButton) {
        if let vc = UIStoryboard(name: "Authorize", bundle: Bundle.main).instantiateInitialViewController() {
            present(vc, animated: true, completion: nil)
        }
    }
}

