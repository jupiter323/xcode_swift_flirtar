//
//  LoginInteractor.swift
//  FlirtARViper
//
//  Created by   on 01.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class LoginInteractor: LoginInteractorInputProtocol {
    
    var presenter: LoginIntercatorOutputProtocol?
    var remoteDatamanager: LoginRemoteDatamanagerInputProtocol?
    var localDatamanager: LoginLocalDatamanagerInputProtocol?
    
    func login(with email: String, password: String) {
        remoteDatamanager?.requestLogin(with: email, password: password)
    }
    
    func loginWithFB() {
        remoteDatamanager?.requestLoginWithFB()
    }
    
    
}

extension LoginInteractor: LoginRemoteDatamanagerOutputProtocol {
    
    func loggedIn() {
        
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
        
        
        
        
        presenter?.loggedInSuccess()
    }
    func loginError(method: APIMethod, error: Error) {
        presenter?.errorWhileLogIn(method: method, error: error)
    }
}
