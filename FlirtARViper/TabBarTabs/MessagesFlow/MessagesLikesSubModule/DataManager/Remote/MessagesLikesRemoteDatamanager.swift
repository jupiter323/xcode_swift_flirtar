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
        let request = APIRouter.getLikesList(page: nil)
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.errorWhileRecievingLikes()
            } else {
                let users = APIParser().parseShortUsers(js: js!["results"])
                let previous = js!["previous"].int
                let current = js!["current"].int
                let next = js!["next"].int
                
                self.remoteRequestHandler?.likesRecieved(likes: users,
                                                         currentPage: current,
                                                         nextPage: next,
                                                         previousPage: previous)
            }
        }
    }
    
    func requestMoreUserLikes(page: Int) {
        let request = APIRouter.getLikesList(page: page)
        
        NetworkManager.shared.sendAPIRequest(request: request) { (js, error) in
            if js != nil {
                let users = APIParser().parseShortUsers(js: js!["results"])
                let previous = js!["previous"].int
                let current = js!["current"].int
                let next = js!["next"].int
                
                self.remoteRequestHandler?.appendLikesRecieved(likes: users,
                                                               currentPage: current,
                                                               nextPage: next,
                                                               previousPage: previous)
                
            }
        }
    }
}
