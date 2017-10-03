//
//  SUPinCodeRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SUPinCodeRemoteDatamanager: SUPinCodeRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:SUPinCodeRemoteDatamanagerOutputProtocol?
    
    func requestPinCodeChecking(withPinCode pin: String, andEmail email: String) {

        let request = APIRouter.checkPinCode(email: email, pinCode: pin)
        
        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    print(response)
                    
                    let js = JSON(response)
                    
                    if js["msg"].stringValue == ServerSignUpJSONKeys.codeMatch.rawValue {
                        self.remoteRequestHandler?.pinCodeCheckSuccess()
                    } else {
                        self.remoteRequestHandler?.pinCodeCheckUnsuccess(method: APIMethod.checkPinCode, error: PinCodeError.pinCodeUnmatch)
                    }
                case .failure(let error):
                    self.remoteRequestHandler?.pinCodeCheckUnsuccess(method: APIMethod.checkPinCode, error: error)
                }
        }
        
        
        
        
        
        
        
        
    }
}
