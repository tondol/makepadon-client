//
//  WelcomeUseCase.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/06/24.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit
import RxSwift
import RxCocoa

protocol WelcomeUseCase {
    
    func verifyCredentials() -> Single<Account>
}

class WelcomeUseCaseImpl: WelcomeUseCase {
    
    func verifyCredentials() -> Single<Account> {
        return Session.rx_sendRequest(request: VerifyCredentialsRequest())
    }
}
