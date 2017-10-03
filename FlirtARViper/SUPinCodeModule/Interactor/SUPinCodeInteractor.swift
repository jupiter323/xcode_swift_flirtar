//
//  SUPinCodeInteractor.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUPinCodeInteractor: SUPinCodeInteractorInputProtocol {
    var presenter: SUPinCodeIntercatorOutputProtocol?
    var remoteDatamanager: SUPinCodeRemoteDatamanagerInputProtocol?
    
    func checkPinCode(withPinCode pin: String) {
        
        guard let email = ProfileService.currentUser?.email else {
            presenter?.pinCodeIsNotCorrect(method: APIMethod.checkPinCode, error: PinCodeError.emailNotExist)
            return
        }
        
        remoteDatamanager?.requestPinCodeChecking(withPinCode: pin, andEmail: email)
    }
}

extension SUPinCodeInteractor: SUPinCodeRemoteDatamanagerOutputProtocol {
    
    func pinCodeCheckSuccess() {
        presenter?.pinCodeIsCorrect()
    }
    func pinCodeCheckUnsuccess(method: APIMethod, error: Error) {
        presenter?.pinCodeIsNotCorrect(method: method, error: error)
    }
}
