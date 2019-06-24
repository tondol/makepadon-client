//
//  AuthorizeUseCase.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/06/24.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit
import RxSwift
import RxCocoa

protocol AuthorizeUseCase {
    
    func retrieveAccessToken(authorizationCode: String) -> Single<AuthorizeResult>
    func storeAccessToken(accessToken: String) -> Single<Void>
}

class AuthorizeUseCaseImpl: AuthorizeUseCase {
    
    func retrieveAccessToken(authorizationCode: String) -> Single<AuthorizeResult> {
        return Session.rx_sendRequest(request: AuthorizeRequest(authorizationCode: authorizationCode))
    }
    
    func storeAccessToken(accessToken: String) -> Single<Void> {
        return Single.create { single in
            MyKeychain.shared[MyKeychain.Keys.AccessToken] = accessToken
            single(.success(()))
            return Disposables.create()
        }
    }
}
