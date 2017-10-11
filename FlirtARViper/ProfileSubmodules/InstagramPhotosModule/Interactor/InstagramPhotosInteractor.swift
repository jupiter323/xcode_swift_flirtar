//
//  InstagramPhotosInteractor.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class InstagramPhotosInteractor: InstagramPhotosInteractorInputProtocol {
    weak var presenter: InstagramPhotosInteractorOutputProtocol?
    var remoteDatamanager: InstagramPhotosRemoteDatamanagerInputProtocol?
    var localDatamanager: InstagramPhotosLocalDatamanagerInputProtocol?
    
    func startGettingInstagramPhotos(userId: Int) {
        remoteDatamanager?.requestInstagramPhotos(userId: userId)
    }
    
    func startInstagramConnection(withToken token: String) {
        remoteDatamanager?.requestInstagramConnection(withToken: token)
    }
}

extension InstagramPhotosInteractor: InstagramPhotosRemoteDatamanagerOutputProtocol {
    func photosRecieved(photos: [String]) {
        presenter?.didRecievePhotos(photos: photos)
    }
    
    func instagramConnected() {
        
        ProfileService.savedUser?.instagramConnected = true
        ProfileService.currentUser?.instagramConnected = true
        
        if let userId = ProfileService.savedUser?.userID {
            do {
                try localDatamanager?.saveInstagramStatus(userId: userId, status: true)
            } catch {
                print("Error while local saving insta status")
            }
        }
        
        NotificationCenter.default
            .post(name: NSNotification.Name(NotificationName.postInstagramTokenChanged.rawValue),
                  object: nil,
                  userInfo: nil)
    }
    
    func requestError(method: APIMethod, error: Error) {
        presenter?.requestError(method: method, error: error)
    }
    
    
    
    
}
