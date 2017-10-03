//
//  SULicenseInteractor.swift
//  FlirtARViper
//
//  Created by on 18.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SULicenseInteractor: SULicenseInteractorInputProtocol {
    var presenter: SULicenseInteractorOutputProtocol?
    var remoteDatamanager: SULicenseRemoteDatamanagerInputProtocol?
    var localDatamanager: SULicenseLocalDatamanagerInputProtocol?
    
    func getLicenseAgreement() {
        remoteDatamanager?.requestLicenseAgreement()
    }
    
    func startSaveProfile() {
        let newUser = ProfileService.currentUser
        guard newUser != nil else {
            presenter?.errorWhileSignUp(method: APIMethod.signUp, error: SignUpError.internalError)
            return
        }
        
        remoteDatamanager?.requestSaveProfile(withUser: newUser!)
    }
    
    func savePhotos() {
        let photos = ProfileService.localPhotos
        remoteDatamanager?.requestSavingPhotos(withPhotos: photos)
    }
}

extension SULicenseInteractor: SULicenseRemoteDatamanagerOutputProtocol {
    
    func licenseRecieved(withText text: String) {
        presenter?.licenseRecieved(withText: text)
    }
    
    func licenseRecieveError(method: APIMethod, error: Error) {
        presenter?.licenseRecieveError(method: method, error: error)
    }
    
    func profileSaved() {
        ProfileService.currentUser = ProfileService.savedUser
        
        //save user from signIn and FBAuth
        if let user = ProfileService.savedUser,
            let token = ProfileService.token {
            do {
                try localDatamanager?.clearDB()
                try localDatamanager?.saveUser(user: user, token: token)
            } catch {
                print("Error while local saving profile")
            }
        }
        
        presenter?.profileSavedSuccess()
    }
    
    func profileSaveError(method: APIMethod, error: Error) {
        presenter?.errorWhileSignUp(method: method, error: error)
    }
    
    func fillFieldsError(method: APIMethod, errors: [Error]) {
        presenter?.errorWhileFillingFields(method: method, errors: errors)
    }
    
    func photosUploaded(photos: [Photo]) {
        ProfileService.recievedPhotos = photos
        
        //update record and save photos
        if let userId = ProfileService.savedUser?.userID {
            do {
                try localDatamanager?.savePhotos(photos: photos, forUser: userId)
            } catch {
                print("Error while local saving photos")
            }
        }
        
        presenter?.photosUploadSuccess()
    }
    
    func photosUploadError(method: APIMethod, error: Error) {
        presenter?.errorWhileUploadingPhotos(method: method, error: error)
    }
}
