//
//  ListPresenter.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/06/24.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import RxSwift
import RxCocoa

class ListPresenter: NSObject {
    
    private let bag = DisposeBag()
    
    private var useCase: ListUseCase
    
    let tootDidSuccessMessage = PublishRelay<Void>()
    let tootDidFailMessage = PublishRelay<Void>()
    let logoutDidSuccessMessage = PublishRelay<Void>()
    let statusList = BehaviorRelay(value: [Status]())
    
    init(useCase: ListUseCase) {
        self.useCase = useCase
    }
    
    func fetchStatusList() {
        useCase.fetchStatusList()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [unowned self] statusList -> Void in
                self.statusList.accept(statusList)
            })
            .disposed(by: bag)
    }
    
    func toot(content: String) {
        useCase.toot(content: content)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [unowned self] statusList -> Void in
                self.tootDidSuccessMessage.accept(())
            }, onError: { [unowned self] _ -> Void in
                self.tootDidFailMessage.accept(())
            })
            .disposed(by: bag)
    }
    
    func logout() {
        useCase.logout()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [unowned self] statusList -> Void in
                self.logoutDidSuccessMessage.accept(())
            })
            .disposed(by: bag)
    }
}

// MARK: - UITableView の protocol

extension ListPresenter: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListCell
        c.setup(status: statusList.value[indexPath.row])
        return c
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
