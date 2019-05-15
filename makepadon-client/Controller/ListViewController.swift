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
    
    fileprivate var statusList = [Status]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 戻るボタンを無効化する。
        navigationItem.hidesBackButton = true
        
        // トゥートボタンをの設定。
        let logoutButton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(didTapLogoutButton(sender:)))
        navigationItem.rightBarButtonItem = logoutButton
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // トゥートボタンの有効無効を切り替える。
        contentTextField.rx.text
            .asDriver()
            .map { $0?.isEmpty == false }
            .drive(tootButton.rx.isEnabled)
            .disposed(by: bag)
        
        tootButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ -> Void in
                guard let content = self?.contentTextField?.text, !content.isEmpty else { return }
                
                self?.contentTextField.text = nil
                
                self?.toot(content: content)
            })
            .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchStatusList()
    }
    
    // この辺は Presenter に切り出したいやつですね。
    fileprivate func fetchStatusList() {
        Session.rx_sendRequest(request: PublicTimelineRequest())
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] statusList in
                self?.statusList = statusList
                
                self?.tableView?.reloadData()
            })
            .disposed(by: bag)
    }
    
    fileprivate func toot(content: String) {
        Session.rx_sendRequest(request: PostStatusRequest(content: content))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] statusList in
                self?.fetchStatusList()
            })
            .disposed(by: bag)
    }
    
    @IBAction func didTapLogoutButton(sender: UIBarButtonItem) {
        try? MyKeychain.shared.remove(MyKeychain.Keys.AccessToken)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView の protocol

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListCell
        let data = statusList[indexPath.row]
        c.iconImageView.kf.setImage(with: URL(string: data.account.avatar)!)
        c.titleLabel.text = "@\(data.account.username) - \(data.account.displayName)"
        c.descriptionLabel.text = data.content
        return c
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
