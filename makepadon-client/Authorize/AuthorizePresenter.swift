//
//  AuthorizePresenter.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/06/24.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit
import RxSwift
import RxCocoa

class AuthorizePresenter {
    
    private let bag = DisposeBag()
    
    private var useCase: AuthorizeUseCase
    
    let retrieveDidSuccessMessage = PublishRelay<Void>()
    let retrieveDidFailMessage = PublishRelay<Void>()
    
    init(useCase: AuthorizeUseCase) {
        self.useCase = useCase
    }
    
    func retrieveAccessToken(authorizationCode: String) {
        useCase.retrieveAccessToken(authorizationCode: authorizationCode)
            .observeOn(MainScheduler.instance)
            .flatMap { [unowned self] result -> Single<Void> in
                return self.useCase.storeAccessToken(accessToken: result.accessToken)
            }
            .subscribe(onSuccess: { [unowned self] _ -> Void in
                self.retrieveDidSuccessMessage.accept(())
            }, onError: { [unowned self] error -> Void in
                self.retrieveDidFailMessage.accept(())
            })
            .disposed(by: bag)
    }
}
