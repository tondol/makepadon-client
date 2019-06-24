//
//  VerifyCredentialsRequest.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit

struct Account: Decodable {
    
    let id: String
    let username: String
    let displayName: String
    let avatar: String
}

struct VerifyCredentialsRequest: MakepaRequestType {
    
    typealias Response = Account
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/v1/accounts/verify_credentials"
    }
}
