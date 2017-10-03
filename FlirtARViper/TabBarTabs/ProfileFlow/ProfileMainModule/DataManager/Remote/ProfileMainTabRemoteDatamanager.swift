//
//  ProfileMainTabRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProfileMainTabRemoteDatamanager: ProfileMainTabRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:ProfileMainTabRemoteDatamanagerOutputProtocol?
    func requestUserProfile() {
        //request here
        let request = APIRouter.getUserProfile()
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.profileRecievingError(method: APIMethod.getProfile, error: error!)
            } else {
                if js!.dictionaryObject != nil {
                    let profile = User(JSON: js!.dictionaryObject!)
                    
                    let photos = APIParser().parsePhotos(js: js!["photos"])
                    self.remoteRequestHandler?.photosRecievedSuccess(photos: photos)
                    
                    
                    if profile != nil {
                        ProfileService.savedUser = profile
                        self.remoteRequestHandler?.profileRecievedSuccess(profile: profile!)
                    } else {
                        self.remoteRequestHandler?.profileRecievingError(method: APIMethod.getProfile, error: GetProfileError.profileResponseError)
                    }
                } else {
                    self.remoteRequestHandler?.profileRecievingError(method: APIMethod.getProfile, error: GetProfileError.profileLoadingError)
                }
            }
        }
        
        
    }
    
    func requestUpdateMapStatus(withProfile: User) {
        let request = APIRouter.updateUserProfile(user: withProfile)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.profileUpdateError(method: APIMethod.updateProfile, error: error!)
                } else {
                    if js!.dictionaryObject != nil {
                        ProfileService.savedUser = User(JSON: js!.dictionaryObject!)
                        self.remoteRequestHandler?.profileUpdatedSuccess()
                    } else {
                        self.remoteRequestHandler?.photosUpdateError(method: APIMethod.updateProfile, error: UpdateProfileError.profileResponseError)
                    }
                }
        }
    }
    
    func requestUpdatePhotos(images: [UIImage]) {
        
        print("DEBUG Profile Remote: Start upload photos")
        
        let updater = PhotoUpdateService()
        updater.uploadPhotosToServer(images: images) { (updated, photos) in
            if updated {
                self.remoteRequestHandler?.photosRecievedSuccess(photos: photos!)
            } else {
                self.remoteRequestHandler?.photosUpdateError(method: APIMethod.updateProfile, error: PhotosUploadError.photosNotUploaded)
            }
        }
    }
}
