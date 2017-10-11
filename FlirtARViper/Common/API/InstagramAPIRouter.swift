//
//  InstagramAPIRouter.swift
//  FlirtARViper
//
//  Created by on 27.09.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import Alamofire


struct InstagramAPI {
    static let apiLink = "https://api.instagram.com/"
    static fileprivate let clientId = "f9611ef5d49845b394322caa3e9078b1"
    static fileprivate let clientSecret = "33b5ea2df1434a8b9e31130584db6f2a"
    static fileprivate let redirectUri = "http://localhost/"
    static fileprivate let apiVersion = "v1/"
}

enum InstagramAPIRouter: URLRequestConvertible, RequestRouter {
    
    case auth
    
    var method: HTTPMethod {
        switch self {
        case .auth:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .auth:
            return "oauth/authorize/?client_id=\(InstagramAPI.clientId)&redirect_uri=\(InstagramAPI.redirectUri)&response_type=token&DEBUG=True"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .auth:
            return nil
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        
        let urlString = try InstagramAPI.apiLink.asURL()
        let urlLink = URL(string: path, relativeTo: urlString)
        var urlRequest = URLRequest(url: urlLink!)
        
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
}
