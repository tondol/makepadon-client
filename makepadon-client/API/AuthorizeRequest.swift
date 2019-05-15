//
//  AuthorizeRequest.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit

struct AuthorizeResult: Decodable {
    
    let accessToken: String
}

struct AuthorizeRequest: MakepaRequestType {

    typealias Response = AuthorizeResult
    
    var authorizationCode: String
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/oauth/token"
    }
    
    var bodyParameters: BodyParameters? {
        return FormURLEncodedBodyParameters(formObject: [
            "grant_type": "authorization_code",
            "redirect_uri": Constants.RedirectUri,
            "client_id": Constants.ClientId,
            "client_secret": Constants.ClientSecret,
            "code": authorizationCode,
            ], encoding: .utf8)
    }
}
