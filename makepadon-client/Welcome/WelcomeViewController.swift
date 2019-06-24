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
import RxCocoa

class WelcomeViewController: UIViewController {
    
    @IBOutlet fileprivate weak var button: UIButton!
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var presenter: WelcomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WelcomePresenter(useCase: WelcomeUseCaseImpl())
        setupBindings()
    }
    
    private func setupBindings() -> Void {
        presenter.verifyCredentialsDidSuccessMessage
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive(onNext: { [unowned self] _ in
                let vc = ListViewController.instantiateFromStoryboard(storyboard: "Main")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.verifyCredentials()
    }
    
    @IBAction func didTapButton(sender: UIButton) {
        guard let vc = UIStoryboard(name: "Authorize", bundle: Bundle.main).instantiateInitialViewController() else { return }
        self.present(vc, animated: true, completion: nil)
    }
}

