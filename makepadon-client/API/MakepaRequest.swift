//
//  MakepaRequest.swift
//  makepadon-client
//
//  Created by Hosaka Tomoyuki on 2019/05/13.
//  Copyright © 2019年 Hosaka Tomoyuki. All rights reserved.
//

import APIKit

class DecodableDataParser: DataParser {
    
    var contentType: String? {
        return "application/json"
    }
    
    func parse(data: Data) throws -> Any {
        return data
    }
}

protocol MakepaRequestType: Request {
    
    associatedtype DecodableElement = Any
    
    // これがないとextension側の実装がコールされない
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response
    func intercept(urlRequest: URLRequest) throws -> URLRequest
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any
}

extension MakepaRequestType {
    
    var baseURL: URL {
        return URL(string: Constants.MastodonHost)!
    }
    
    var dataParser: DataParser {
        return DecodableDataParser()
    }
    
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        // 認証付きリクエスト。
        let accessToken = MyKeychain.shared[MyKeychain.Keys.AccessToken]
        if let accessToken = accessToken, !accessToken.isEmpty {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        let method = urlRequest.httpMethod ?? ""
        let url = urlRequest.url?.absoluteString ?? ""
        let headers = urlRequest.allHTTPHeaderFields ?? [String: String]()
        let body = urlRequest.httpBody ?? Data()
        
        print("")
        print("************************************************************")
        print("*** REQUEST ************************************************")
        print("METHOD = \(method)")
        print("URL = \(url)")
        print("HEADERS = \(headers)")
        print("BODY = \(body)")
        print("************************************************************")
        print("")
        
        // サイズが小さい場合は本文もログに表示する。
        if body.count < 5 * 1024 {
            print("************************************************************")
            print("*** PARAMETER **********************************************")
            print(String(data: body, encoding: .utf8) ?? "")
            print("************************************************************")
            print("")
        }
        
        return urlRequest
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        let status = urlResponse.statusCode
        let url = urlResponse.url?.absoluteString ?? ""
        let headers = urlResponse.allHeaderFields
        
        print("")
        print("************************************************************")
        print("*** RESPONSE ***********************************************")
        print("STATUS = \(status)")
        print("URL = \(url)")
        print("HEADERS = \(headers)")
        print("BODY = \(object)")
        print("************************************************************")
        print("")
        
        return object
    }
}

extension MakepaRequestType where Self.Response: Decodable {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        } catch let error {
            throw error
        }
    }
}

extension MakepaRequestType where Self.Response == [DecodableElement], Self.DecodableElement: Decodable {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Self.Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        } catch let error {
            throw error
        }
    }
}
