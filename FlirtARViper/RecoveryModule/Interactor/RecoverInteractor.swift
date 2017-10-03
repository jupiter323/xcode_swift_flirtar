//
//  RecoverInteractor.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class RecoverInteractor: RecoveryInteractorInputProtocol {
    var presenter: RecoveryIntercatorOutputProtocol?
    var remoteDatamanager: RecoveryRemoteDatamanagerInputProtocol?
    
    func recoverPassword(with email: String) {
        remoteDatamanager?.requestPasswordRecover(with: email)
    }
    
    
    
}


extension RecoverInteractor: RecoveryRemoteDatamanagerOutputProtocol {
    func passwordRecovered() {
        presenter?.passwordRecoverSuccess()
    }
    
    func passwordRecoverError(method: APIMethod, error: Error) {
        presenter?.errorWhilePasswordRecovering(method: method, error: error)
    }
}
