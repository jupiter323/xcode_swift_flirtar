//
//  InstagramPhotosRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class InstagramPhotosRemoteDatamanager: InstagramPhotosRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:InstagramPhotosRemoteDatamanagerOutputProtocol?
    
    func requestInstagramPhotos(userId: Int) {
        
        let request = APIRouter.getInstagramPhotos(userId: userId)
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.photosRecieved(photos: [Photo]())
            } else {
                let photosLinks = APIParser().parseInstagramPhotos(js: js!)
                self.remoteRequestHandler?.photosRecieved(photos: photosLinks)
            }
        }
        
        
    }
    
    func requestInstagramConnection(withToken token: String) {
        let request = APIRouter.saveInstagramToken(token: token)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request, completionHandler: { (error) in
                
                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.postInstagram, error: error!)
                } else {
                    self.remoteRequestHandler?.instagramConnected()
                }
                
            })
    }
    
    
    
    
    
    
    
}
