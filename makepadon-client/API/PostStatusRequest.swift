//
//  PostStatusRequest.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/15.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit

struct PostStatusRequest: MakepaRequestType {
    
    typealias Response = Status
    
    let content: String
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/v1/statuses"
    }
    
    var bodyParameters: BodyParameters? {
        return FormURLEncodedBodyParameters(formObject: [
            "status": content,
            ], encoding: .utf8)
    }
}
