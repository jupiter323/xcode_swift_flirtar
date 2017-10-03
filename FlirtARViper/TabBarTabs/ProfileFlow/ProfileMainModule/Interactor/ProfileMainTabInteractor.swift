//
//  ProfileMainTabInteractor.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit

class ProfileMainTabInteractor: ProfileMainTabInteractorInputProtocol {
    weak var presenter: ProfileMainTabIntercatorOutputProtocol?
    var remoteDatamanager: ProfileMainTabRemoteDatamanagerInputProtocol?
    var localDatamanager: ProfileMainTabLocalDatamanagerInputProtocol?
    
    fileprivate var mapStatus: Bool?
    
    func startLoadingProfile() {
        remoteDatamanager?.requestUserProfile()
    }
    
    
    func startUpdateShowOnMapStatus(status: Bool) {
        mapStatus = ProfileService.currentUser?.showOnMap
        ProfileService.currentUser?.showOnMap = status
        
        guard let user = ProfileService.currentUser else {
            presenter?.errorWhileUpdatingMapStatus(method: APIMethod.updateProfile, error: UpdateProfileError.internalError)
            return
        }
        remoteDatamanager?.requestUpdateMapStatus(withProfile: user)
    }
    
    func startUpdatePhotos(withPhotos photos: [UIImage]) {
        print("DEBUG Profile Interactor: photos - \(photos)")
        remoteDatamanager?.requestUpdatePhotos(images: photos)
    }
    
    func updateProfileFromService() {
        if let user = ProfileService.savedUser {
            presenter?.profileUpdatedFromService(profile: user)
        }
    }
}

//MARK: - ProfileMainTabRemoteDatamanagerOutputProtocol
extension ProfileMainTabInteractor: ProfileMainTabRemoteDatamanagerOutputProtocol {
    func profileRecievedSuccess(profile: User) {
        presenter?.profileRecieved(profile: profile)
    }
    func profileRecievingError(method: APIMethod, error: Error) {
        presenter?.errorWhileLoading(method: method, error: error)
    }
    
    func photosRecievedSuccess(photos: [Photo]) {
        if photos.count != 0 {
            ProfileService.recievedPhotos = photos
            
            if let userId = ProfileService.savedUser?.userID {
                do {
                    try localDatamanager?.savePhotos(photos: photos, forUser: userId)
                } catch {
                    print("Error while saving photos locally")
                }
            }
            
        }
        presenter?.photosRecieved(photos: ProfileService.recievedPhotos)
    }
    
    func photosUpdateError(method: APIMethod, error: Error) {
        presenter?.photosUpdateError(method: method, error: error)
    }
    
    func profileUpdatedSuccess() {
        
        guard let profile = ProfileService.savedUser else {
            ProfileService.currentUser?.showOnMap = mapStatus
            presenter?.errorWhileUpdatingMapStatus(method: APIMethod.updateProfile, error: UpdateProfileError.profileNotValid)
            return
        }
        
        ProfileService.currentUser = ProfileService.savedUser
        
        if let userId = ProfileService.currentUser?.userID,
            let status = ProfileService.currentUser?.showOnMap {
            
            do {
                try localDatamanager?.saveUserMapStatus(userId: userId, status: status)
            } catch {
                print("Error while saving local map status")
            }
            
        }
        
        
        presenter?.profileRecieved(profile: profile)
        
    }
    
    func profileUpdateError(method: APIMethod, error: Error) {
        ProfileService.currentUser?.showOnMap = mapStatus
        presenter?.errorWhileUpdatingMapStatus(method: method, error: error)
    }
}
