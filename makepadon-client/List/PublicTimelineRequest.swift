//
//  PublicTimelineRequest.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/15.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit

struct Status: Decodable {
    
    let id: String
    let uri: String
    let account: Account
    let content: String
}

struct PublicTimelineRequest: MakepaRequestType {
    
    typealias Response = [Status]
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/api/v1/timelines/public"
    }
}
