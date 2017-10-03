//
//  SUEmailRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

class SUEmailRemoteDatamanager: SUEmailRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:SUEmailRemoteDatamanagerOutputProtocol?
    
    func requestEmailAvailability(withEmail email: String) {
        let request = APIRouter.checkEmailAvailability(email: email)
        
        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    print(response)
                    
                    let js = JSON(response)
                    if js["message"] != JSON.null {
                        if js["message"].stringValue == "Email available" {
                            self.remoteRequestHandler?.emailCheckSuccess()
                        } else {
                            self.remoteRequestHandler?.requestError(method: APIMethod.checkEmail, error: EmailCheckError.emailNotAvailable)
                        }
                    } else {
                        self.remoteRequestHandler?.requestError(method: APIMethod.checkEmail, error: EmailCheckError.emailNotAvailable)
                    }
                case .failure(let error):
                    self.remoteRequestHandler?.requestError(method: APIMethod.checkEmail, error: error)
                }
        }
    }
    
    
    
    func requestPinCode(forEmail email: String) {
        let request = APIRouter.sendPinCode(email: email)
        
        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    print(response)
                    
                    let js = JSON(response)
                    
                    if js["msg"].stringValue == ServerSignUpJSONKeys.codeSent.rawValue {
                        self.remoteRequestHandler?.pinCodeSendSuccess()
                    } else {
                        self.remoteRequestHandler?.requestError(method: APIMethod.sendPinCode, error: PinCodeError.pinCodeNotSent)
                    }
                case .failure(let error):
                    self.remoteRequestHandler?.requestError(method: APIMethod.sendPinCode, error: error)
                }
        }
        
    }
    
    
    
    func requestSignUpWithFB() {
        
        let fbService = FBAuthService()
        fbService.fbAuthorize { (token, fbError) in
            //token provided
            guard let accessToken = token  else {
                self.remoteRequestHandler?.requestError(method: APIMethod.signUpFB, error: fbError!)
                return
            }
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
                                self.remoteRequestHandler?.signedUp()
                            } else {
                                self.remoteRequestHandler?.requestError(method: APIMethod.signUpFB, error: LoginError.userResponseError)
                            }
                            
                        } else {
                            //else show error
                            self.remoteRequestHandler?.requestError(method: APIMethod.signUpFB, error: LoginError.noTokenError)
                        }
                    case .failure(let error):
                        print(error)
                        self.remoteRequestHandler?.requestError(method: APIMethod.signUpFB, error: error)
                    }
            }
        }
    }
    
}
