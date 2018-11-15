//
//  ProfileSettingsRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProfileSettingsRemoteDatamanager: ProfileSettingsRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:ProfileSettingsRemoteDatamanagerOutputProtocol?
    
    func requestSaveProfile(withProfile profile: User) {
        let request = APIRouter.updateUserProfile(user: profile)
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.requestError(method: APIMethod.updateProfile, error: error!)
            } else {
                if js!["first_name"] != JSON.null {
                    if js!.dictionaryObject != nil {
                        ProfileService.savedUser = User(JSON: js!.dictionaryObject!)
                        self.remoteRequestHandler?.profileSaved()
                    } else {
                        self.remoteRequestHandler?.requestError(method: APIMethod.updateProfile, error: UpdateProfileError.profileResponseError)
                    }
                    
                } else {
                    //else show error for fields
                    
                    let errors = APIParser().parseSaveProfileErrors(js: js!)
                    
                    self.remoteRequestHandler?.fillFieldsError(method: APIMethod.updateProfile, errors: errors)
                }
            }
        }
        

    }
    
    func requestDeleteProfile() {
        let request = APIRouter.deleteAccount()
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.requestError(method: APIMethod.deleteProfile, error: error!)
            } else {
                self.remoteRequestHandler?.profileDeleted()
            }
        }
    }
}
