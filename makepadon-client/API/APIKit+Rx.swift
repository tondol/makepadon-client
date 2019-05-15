//
//  APIKit+Rx.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit
import RxSwift

extension Session {
    
    func rx_sendRequest<T: Request>(request: T) -> Single<T.Response> {
        return Single.create { single in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    single(.success(res))
                case .failure(let err):
                    single(.error(err))
                }
            }
            
            return Disposables.create { [weak task] in
                task?.cancel()
            }
        }
    }
    
    class func rx_sendRequest<T: Request>(request: T) -> Single<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}
