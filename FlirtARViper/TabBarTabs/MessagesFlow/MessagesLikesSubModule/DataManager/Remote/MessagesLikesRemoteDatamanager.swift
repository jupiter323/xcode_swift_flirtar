//
//  MessagesLikesRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class MessagesLikesRemoteDatamanager: MessagesLikesRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:MessagesLikesRemoteDatamanagerOutputProtocol?
    
    func requestUserLikes() {
        let request = APIRouter.getLikesList()
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.errorWhileRecievingLikes()
            } else {
                let users = APIParser().parseShortUsers(js: js!["results"])
                self.remoteRequestHandler?.likesRecieved(likes: users)
            }
        }
    }
}
