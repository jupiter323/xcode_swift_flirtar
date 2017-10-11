//
//  SplashInteractor.swift
//  FlirtARViper
//
//  Created by on 19.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SplashInteractor: SplashInteractorInputProtocol {
    weak var presenter: SplashIntercatorOutputProtocol?
    var remoteDatamanager: SplashRemoteDatamanagerInputProtocol?
    var localDatamanager: SplashLocalDatamanagerInputProtocol?
    
    func startLoginWithFB() {
        remoteDatamanager?.requestLoginWithFB()
    }
}

extension SplashInteractor: SplashRemoteDatamanagerOutputProtocol {
    func loggedIn() {
        
        ProfileService.currentUser = ProfileService.savedUser
        
        if ProfileService.recievedPhotos.count == 3 {
            if let user = ProfileService.savedUser,
                let token = ProfileService.token {
                do {
                    try localDatamanager?.clearDB()
                    try localDatamanager?.saveUser(user: user, token: token, photos:  ProfileService.recievedPhotos)
                } catch {
                    print("Error while local saving")
                }
            }
        }
        
        presenter?.loggedInSuccess()
    }
    
    func fbAuthFinished() {
        presenter?.fbAuthFinished()
    }
    
    func loginError(method: APIMethod, error: Error) {
        presenter?.errorWhileLogIn(method: method, error: error)
    }
}
