//
//  MyKeychain.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import KeychainAccess

class MyKeychain {
    
    static var shared = Keychain(service: Constants.KeychainService)
    
    enum Keys {
        
        static let AccessToken = "AccessToken"
    }
}
