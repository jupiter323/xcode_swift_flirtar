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
    
    
    func startUpdatePhotos(withPhotos photos: [UIImage]) {
        print("DEBUG Profile Interactor: photos - \(photos)")
        remoteDatamanager?.requestUpdatePhotos(images: photos)
    }
    
    func startReplacePhoto(withPhoto newPhoto: UIImage,
                           replacePhoto oldPhoto: Photo) {
        remoteDatamanager?.requestReplacePhoto(newPhoto: newPhoto,
                                               oldPhoto: oldPhoto)
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
    
    func photoReplacedSuccess(newPhoto: Photo,
                              oldPhoto: Photo) {
        var index: Int?
        for i in 0..<ProfileService.recievedPhotos.count {
            let profilePhoto = ProfileService.recievedPhotos[i]
            if profilePhoto.photoID == newPhoto.photoID {
                index = i
                break
            }
        }
        
        if index != nil {
            ProfileService.recievedPhotos[index!] = newPhoto
        }
        
        presenter?.photosRecieved(photos: ProfileService.recievedPhotos)
    }
    
    func photoReplaceError(method: APIMethod, error: Error) {
        presenter?.photosUpdateError(method: method, error: error)
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
    
}
