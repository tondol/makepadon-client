//
//  ListViewController.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/04/15.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import UIKit
import Kingfisher
import APIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var contentTextField: UITextField!
    @IBOutlet fileprivate weak var tootButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var presenter: ListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        presenter = ListPresenter(useCase: ListUseCaseImpl())
        
        tableView.dataSource = presenter
        tableView.delegate = presenter
        
        setupBindings()
    }
    
    private func setupUI() {
        // 戻るボタンを無効化する。
        navigationItem.hidesBackButton = true
        
        // ログアウトボタンの設定。
        let logoutButton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(didTapLogoutButton(sender:)))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setupBindings() {
        // トゥートボタンの有効無効を切り替える。
        contentTextField.rx.text
            .asDriver()
            .map { $0?.isEmpty == false }
            .drive(tootButton.rx.isEnabled)
            .disposed(by: bag)
        
        tootButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] _ -> Void in
                guard let content = self.contentTextField?.text, !content.isEmpty else { return }
                
                self.contentTextField.text = nil
                
                self.presenter.toot(content: content)
            })
            .disposed(by: bag)
        
        presenter.logoutDidSuccessMessage
            .asSignal()
            .emit(onNext: { [unowned self] _ -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
        presenter.statusList
            .asSignal(onErrorSignalWith: Signal.empty())
            .emit(onNext: { [unowned self] _ -> Void in
                self.tableView.reloadData()
            })
            .disposed(by: bag)
        
        presenter.tootDidSuccessMessage
            .asSignal()
            .emit(onNext: { [unowned self] _ -> Void in
                self.presenter.fetchStatusList()
            })
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.fetchStatusList()
    }
    
    @IBAction func didTapLogoutButton(sender: UIBarButtonItem) {
        presenter.logout()
    }
}
