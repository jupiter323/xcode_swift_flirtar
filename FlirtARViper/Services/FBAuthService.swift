//
//  FBAuthService.swift
//  FlirtARViper
//
//  Created by   on 03.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

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
    private var loginManager = LoginManager()
    private func fbLogout() {
        loginManager.logOut()
        AccessToken.current = nil
    }
    
    
    
    private let neededPermissions = [ReadPermission.publicProfile,
                                     ReadPermission.email,
                                     ReadPermission.custom("user_birthday"),
                                     ReadPermission.custom("user_photos")]
    
    //MARK: - Public
    func fbAuthorize(completionHandler: @escaping (_ accessToken: String?, _ error: FBAuthError?) -> ()) {
        
        fbLogout()
        
        loginManager.loginBehavior = .browser
        
        loginManager
            .logIn(neededPermissions,
                   viewController: nil) { (result) in
                    switch result {

                    case .failed(let error):
                        print("DEBUG FBAuthError: \(error.localizedDescription)")
                        self.fbLogout()
                        completionHandler(nil, .fbInternalError)
                    case .cancelled:
                        self.fbLogout()
                        completionHandler(nil, .userCancelFlow)
                        
                    case .success(_, let declinedPermissions, let token):
                        
                        //all permissions granted
                        if declinedPermissions.isEmpty {
                            completionHandler(token.authenticationToken, nil)
                        } else {
                            //else
                            completionHandler(nil, .permissionsNotGranted)
                        }
                        
                    }
        }

    }
    
    
}
