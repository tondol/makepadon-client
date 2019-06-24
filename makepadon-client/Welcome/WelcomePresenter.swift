//
//  WelcomePresenter.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/06/24.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import RxSwift
import RxCocoa

class WelcomePresenter {
    
    private let bag = DisposeBag()
    
    private var useCase: WelcomeUseCase
    
    let verifyCredentialsDidSuccessMessage = PublishRelay<Void>()
    
    init(useCase: WelcomeUseCase) {
        self.useCase = useCase
    }
    
    func verifyCredentials() {
        useCase.verifyCredentials()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [unowned self] _ in
                self.verifyCredentialsDidSuccessMessage.accept(())
            })
            .disposed(by: bag)
    }
}
