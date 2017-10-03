//
//  LoginRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by   on 01.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class LoginRemoteDatamanager: LoginRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:LoginRemoteDatamanagerOutputProtocol?
    
    
    func requestLogin(with email: String, password: String) {
        
        let request = APIRouter.signIn(email: email, password: password)
        
        Alamofire
        .request(request)
        .responseJSON { (response) in
            switch response.result {
            case .success(let response):
                print(response)
                let js = JSON(response)
                
                //check token
                //if exist -> created user and save it
                if js["token"] != JSON.null {
                    
                    let userTuple = APIParser().parseUser(js: js)
                    
                    if userTuple.user != nil && userTuple.token != nil {
                        ProfileService.savedUser = userTuple.user
                        ProfileService.recievedPhotos = userTuple.photos
                        ProfileService.token = userTuple.token
                        self.remoteRequestHandler?.loggedIn()
                    } else {
                        self.remoteRequestHandler?.loginError(method: APIMethod.signIn, error: LoginError.userResponseError)
                    }
                    
                } else {
                    //else show error
                    if js["non_field_errors"] != JSON.null {
                        self.remoteRequestHandler?.loginError(method: APIMethod.signIn, error: LoginError.credentialsIncorrectError)
                    }
                }
                
            case .failure(let error):
                self.remoteRequestHandler?.loginError(method: APIMethod.signIn, error: error)
            }
        }
        
        
    }
    
    func requestLoginWithFB() {
        
        //token not provided, check errors
        let fbService = FBAuthService()
        fbService.fbAuthorize { (token, fbError) in
            
            guard let accessToken = token  else {
                self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: fbError!)
                return
            }
            //token provided
            let request = APIRouter.signInFB(accessToken: accessToken)
            
            Alamofire
                .request(request)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let response):
                        print(response)
                        let js = JSON(response)
                        
                        if js["token"] != JSON.null {
                            
                            let userTuple = APIParser().parseUser(js: js)
                            
                            if userTuple.user != nil && userTuple.token != nil {
                                ProfileService.savedUser = userTuple.user
                                ProfileService.recievedPhotos = userTuple.photos
                                ProfileService.token = userTuple.token
                                self.remoteRequestHandler?.loggedIn()
                            } else {
                                self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: LoginError.userResponseError)
                            }
                            
                            
                        } else {
                            self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: LoginError.noTokenError)
                        }
                        
                    case .failure(let error):
                        self.remoteRequestHandler?.loginError(method: APIMethod.signUpFB, error: error)
                    }
            }
        }
                
    }
    
}
