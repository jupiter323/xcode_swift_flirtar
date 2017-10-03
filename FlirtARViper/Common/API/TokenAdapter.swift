//
//  TokenAdapter.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire


//Auth adapter
class TokenAdapter:RequestAdapter {
    private let token: String
    
    init(accessToken: String) {
        self.token = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(API.apiLink) {
            urlRequest.setValue("Token \(token)", forHTTPHeaderField: "authorization")
        }
        return urlRequest
        
    }
}
