//
//  SUEmailInteractor.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUEmailInteractor: SUEmailInteractorInputProtocol {
    var presenter: SUEmailIntercatorOutputProtocol?
    var remoteDatamanager: SUEmailRemoteDatamanagerInputProtocol?
    var localDatamanager: SUEmailLocalDatamanagerInputProtocol?
    
    fileprivate var checkableEmail: String?
    
    func checkEmailAvailability(with email: String) {
        checkableEmail = email
        remoteDatamanager?.requestEmailAvailability(withEmail: email)
    }
    
    func sendPinCode() {
        
        if let email = checkableEmail {
            remoteDatamanager?.requestPinCode(forEmail: email)
        } else {
//            presenter?.requestError(method: , error: )
        }
        
    }
    
    func signUpWithFB() {
        remoteDatamanager?.requestSignUpWithFB()
    }
}

extension SUEmailInteractor: SUEmailRemoteDatamanagerOutputProtocol {
    
    func emailCheckSuccess() {
        ProfileService.currentUser?.email = checkableEmail
        presenter?.emailIsAvailable()
    }
    
    func signedUp() {
        ProfileService.currentUser = ProfileService.savedUser
        
        if let user = ProfileService.savedUser,
            let token = ProfileService.token{
            do {
                try localDatamanager?.clearDB()
                try localDatamanager?.saveUser(user: user, token: token, photos:  ProfileService.recievedPhotos)
            } catch {
                print("Error while local saving")
            }
        }
        
        presenter?.signUpSuccess()
    }
    
    func pinCodeSendSuccess() {
        presenter?.pinCodeSendSuccess()
    }
    
    func requestError(method: APIMethod, error: Error) {
        presenter?.requestError(method: method, error: error)
    }
    
}
