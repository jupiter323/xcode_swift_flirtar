//
//  FBAuthService.swift
//  FlirtARViper
//
//  Created by   on 03.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

enum FBAuthError: Error {
    case userCancelFlow
    case fbInternalError
    case permissionsNotGranted
    case noAccessToken
    
    var localizedDescription: String {
        switch self {
        case .fbInternalError:
            return "Facebook internal error"
        case .noAccessToken:
            return "No access token"
        case .permissionsNotGranted:
            return "Permissions not granted"
        case .userCancelFlow:
            return "User cancel login flow"
        }
    }
    
}


class FBAuthService {
    
    
    //MARK: - Private
    private var loginManager = FBSDKLoginManager()
    private func fbLogout() {
        loginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
    
    private let neededPermissions = ["public_profile", "email", "user_birthday", "user_photos"]
    
    //MARK: - Public
    func fbAuthorize(completionHandler: @escaping (_ accessToken: String?, _ error: FBAuthError?) -> ()) {
        
        fbLogout()
        
        loginManager.loginBehavior = .web
        loginManager.logIn(withReadPermissions: neededPermissions, from: nil) { (result, error) in
            if (error != nil) {
                self.fbLogout()
                completionHandler(nil, .fbInternalError)
            } else if (result?.isCancelled)! {
                self.fbLogout()
                completionHandler(nil, .userCancelFlow)
            } else {
                //Success
                
                if self.checkGrantedPermissions(result: result, permissions: self.neededPermissions) {
                    
                    guard let accessToken = result?.token?.tokenString else {
                        completionHandler(nil, .noAccessToken)
                        return
                    }
                    
                    completionHandler(accessToken, nil)
                    
                } else {
                    completionHandler(nil, .permissionsNotGranted)
                }
            }
        }

    }
    
    func checkGrantedPermissions(result: FBSDKLoginManagerLoginResult?, permissions: [String]) -> Bool {
        
        
        for eachPermission in permissions {
            if result?.grantedPermissions.contains(eachPermission) == false {
                return false
            }
        }
        
        return true
    }
    
    
}
