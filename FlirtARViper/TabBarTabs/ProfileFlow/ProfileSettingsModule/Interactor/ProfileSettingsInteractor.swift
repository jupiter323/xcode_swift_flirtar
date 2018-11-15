//
//  ProfileSettingsInteractor.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation

class ProfileSettingsInteractor: ProfileSettingsInteractorInputProtocol {
    weak var presenter: ProfileSettingsIntercatorOutputProtocol?
    var remoteDatamanager: ProfileSettingsRemoteDatamanagerInputProtocol?
    var localDatamanager: ProfileSettingsLocalDatamanagerInputProtocol?
    
    func saveProfile() {
        let profile = ProfileService.currentUser
        guard profile != nil else {
            presenter?.requestError(method: APIMethod.updateProfile, error: UpdateProfileError.internalError)
            return
        }
        
        let fillErrors = profile!.validateForUpdate()
        if fillErrors.isEmpty {
            remoteDatamanager?.requestSaveProfile(withProfile: profile!)
        } else {
            presenter?.errorWhileFillingFields(method: APIMethod.updateProfile, errors: fillErrors)
        }
        
    }
    
    func deleteProfile() {
        remoteDatamanager?.requestDeleteProfile()
    }
}

extension ProfileSettingsInteractor: ProfileSettingsRemoteDatamanagerOutputProtocol {
    func profileSaved() {
        
        ProfileService.currentUser = ProfileService.savedUser
        
        if let userId = ProfileService.savedUser?.userID,
            let user = ProfileService.savedUser {
            do {
                try localDatamanager?.updateProfile(withProfile: user, userId: userId)
            } catch {
                print("Error while updating user locally")
            }
        }
        
        presenter?.saveSuccess()
    }
    
    func profileDeleted() {
        LocationService.shared.delegate = nil
        ProfileService.clearProfileService()
        
        do {
            try localDatamanager?.clearUser()
        } catch {
            print("Error while removing user locally")
        }
        
        presenter?.deleteSuccess()
        
    }
    
    func requestError(method: APIMethod, error: Error) {
        presenter?.requestError(method: method, error: error)
    }
    
    func fillFieldsError(method: APIMethod, errors: [Error]) {
        presenter?.errorWhileFillingFields(method: method, errors: errors)
    }
}
