//
//  RecoverRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecoverRemoteDatamanager: RecoveryRemoteDatamanagerInputProtocol {
    var remoteRequestHandler: RecoveryRemoteDatamanagerOutputProtocol?
    
    func requestPasswordRecover(with email: String) {
        
        let request = APIRouter.recoverPassword(email: email)
        
        
        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    print(response)
                    let js = JSON(response)
                    
                    if js["msg"].stringValue == ServerSignUpJSONKeys.passwordRecover.rawValue {
                        self.remoteRequestHandler?.passwordRecovered()
                    } else {
                        self.remoteRequestHandler?.passwordRecoverError(method: APIMethod.passwordRecover, error: PasswordRecoverError.emailNotSended)
                    }
                    
                case .failure(let error):
                    self.remoteRequestHandler?.passwordRecoverError(method: APIMethod.passwordRecover, error: error)
                }
        }
        
        
        
        
        
    }
}
