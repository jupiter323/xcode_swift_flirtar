//
//  SUProfileInfoInteractor.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUProfileInfoInteractor: SUProfileInfoInteractorInputProtocol {
    
    weak var presenter: SUProfileInfoIntercatorOutputProtocol?
    var remoteDatamanager: SUProfileInfoRemoteDatamanagerInputProtocol?
    var localDatamanager: SUProfileInfoLocalDatamanagerInputProtocol?

    func signUp() {
        print("DEBUG SUProfile Interactor: Start sign up")
        let newUser = ProfileService.currentUser
        guard newUser != nil else {
            presenter?.errorWhileSignUp(method: APIMethod.signUp, error: SignUpError.internalError)
            return
        }
        
        let fillErrors = newUser!.validateForSignUp()
        if fillErrors.isEmpty {
            remoteDatamanager?.requestSignUp(withUser: newUser!)
        } else {
            presenter?.errorWhileFillingFields(method: APIMethod.signUp, errors: fillErrors)
        }
    }
    
    func savePhotos() {
        print("DEBUG SUProfile Interactor: Start save photos - \(ProfileService.localPhotos)")
        let photos = ProfileService.localPhotos
        remoteDatamanager?.requestSavingPhotos(withPhotos: photos)
    }

    
    func saveShowOnMapStatus(status: Bool) {
        ProfileService.currentUser?.showOnMap = status
    }
    
    
}


extension SUProfileInfoInteractor: SUProfileInfoRemoteDatamanagerOutputProtocol {
    func signedUp() {
        
        print("DEBUG SUProfile Interactor: Signed Up")
        
        ProfileService.currentUser = ProfileService.savedUser
        
        print("DEBUG SUProfile Interactor: Signed Up Current - \(ProfileService.currentUser)")
        print("DEBUG SUProfile Interactor: Signed Up Saved - \(ProfileService.savedUser)")
        
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
        
        presenter?.signUpSuccess()
    }
    
    func photosUploaded(photos: [Photo]) {
        
        print("DEBUG SUProfile Interactor: Photos uploaded - \(photos)")
        
        ProfileService.recievedPhotos = photos
        
        print("DEBUG SUProfile Interactor: Recieved photos - \(ProfileService.recievedPhotos)")
        
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
    
    func signUpError(method: APIMethod, error: Error) {
        print("DEBUG SUProfile Interactor: Sign error")
        presenter?.errorWhileSignUp(method: method, error: error)
    }
    
    func fillFieldsError(method: APIMethod, errors: [Error]) {
        print("DEBUG SUProfile Interactor: Fill fields error")
        presenter?.errorWhileFillingFields(method: method, errors: errors)
    }
    
    func photosUploadError(method: APIMethod, error: Error) {
        print("DEBUG SUProfile Interactor: Photos upload error")
        presenter?.errorWhileUploadingPhotos(method: method, error: error)
    }
}

