//
//  MyPlist.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/15.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import Foundation

class MyPlist {
    
    static var shared = MyPlist()
    
    var dictionary: [String: String]
    
    init() {
        let filePath = Bundle.main.path(forResource: "private", ofType:"plist" )
        dictionary = NSDictionary(contentsOfFile: filePath!) as! [String: String]
    }
    
    enum Keys {
        static let ClientId = "ClientId"
        static let ClientSecret = "ClientSecret"
        static let MastodonHost = "MastodonHost"
    }
}
