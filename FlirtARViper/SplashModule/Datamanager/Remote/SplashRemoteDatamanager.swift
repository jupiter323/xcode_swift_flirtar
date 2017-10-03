//
//  SplashRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by on 19.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import SwiftyJSON

class SplashRemoteDatamanager: SplashRemoteDatamanagerInputProtocol {
    
    weak var remoteRequestHandler:SplashRemoteDatamanagerOutputProtocol?
    
    func requestLoginWithFB() {
        //token not provided, check errors
        let fbService = FBAuthService()
        fbService.fbAuthorize { (token, fbError) in
            
            guard let accessToken = token  else {
                self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: fbError!)
                return
            }
            
            NetworkManager.shared.clearURLCache()
            
            //token provided
            let request = APIRouter.signInFB(accessToken: accessToken)
            
            NetworkManager
            .shared
            .sendAPIRequest(request: request, completionHandler: { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: error!)
                } else {
                    guard js!["token"] != JSON.null else {
                        self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: LoginError.noTokenError)
                        return
                    }
                    
                    let userTuple = APIParser().parseUser(js: js!)
                    
                    if userTuple.user != nil && userTuple.token != nil {
                        ProfileService.savedUser = userTuple.user
                        ProfileService.recievedPhotos = userTuple.photos
                        ProfileService.token = userTuple.token
                        self.remoteRequestHandler?.loggedIn()
                    } else {
                        self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: LoginError.userResponseError)
                    }
                    
                }
            })
        }
    }
}
