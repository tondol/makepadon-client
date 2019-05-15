//
//  Constants.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import Foundation

enum Constants {
    
    static let ClientId = MyPlist.shared.dictionary[MyPlist.Keys.ClientId]!
    static let ClientSecret = MyPlist.shared.dictionary[MyPlist.Keys.ClientSecret]!
    static let MastodonHost = MyPlist.shared.dictionary[MyPlist.Keys.MastodonHost]!
    static let KeychainService = "com.tondol.makepadon.makepadon-client"
    static let RedirectUri = "urn:ietf:wg:oauth:2.0:oob"
}
