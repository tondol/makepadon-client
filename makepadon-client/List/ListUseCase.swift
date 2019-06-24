//
//  ListUseCase.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/06/24.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit
import RxSwift

protocol ListUseCase {
    
    func fetchStatusList() -> Single<[Status]>
    func toot(content: String) -> Single<Status>
    func logout() -> Single<Void>
}

class ListUseCaseImpl: ListUseCase {
    
    func fetchStatusList() -> Single<[Status]> {
        return Session.rx_sendRequest(request: PublicTimelineRequest())
    }
    
    func toot(content: String) -> Single<Status> {
        return Session.rx_sendRequest(request: PostStatusRequest(content: content))
    }
    
    func logout() -> Single<Void> {
        return Single.create { single in
            try? MyKeychain.shared.remove(MyKeychain.Keys.AccessToken)
            single(.success(()))
            return Disposables.create()
        }
    }
}
