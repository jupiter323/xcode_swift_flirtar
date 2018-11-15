//
//  BlockedUsersRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BlockedUsersRemoteDatamanager: BlockedUsersRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:BlockedUsersRemoteDatamanagerOutputProtocol?
    
    func requestUnblockUser(withId userId: Int) {
        let request = APIRouter.unblockUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.putUnblockUser, error: error!)
                } else {
                    self.remoteRequestHandler?.userUnblocked()
                }
        }
        
    }
    
    func requestLoadUsers() {
        let request = APIRouter.getBlockedUsers(page: nil)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.requestError(method: APIMethod.getBlockedUsers, error: error!)
                } else {
                    let users = APIParser().parseBlockedUsers(js: js!)
                    let previous = js!["previous"].int
                    let current = js!["current"].int
                    let next = js!["next"].int
                    
                    
                    self.remoteRequestHandler?
                        .usersLoaded(users: users,
                                     currentPage: current,
                                     nextPage: next,
                                     previousPage: previous)
                }
        }
        
    }
    
    func requestLoadMoreUsers(page: Int) {
        let request = APIRouter.getBlockedUsers(page: page)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    let users = APIParser().parseBlockedUsers(js: js!)
                    let previous = js!["previous"].int
                    let current = js!["current"].int
                    let next = js!["next"].int
                    
                    
                    self.remoteRequestHandler?
                        .moreUserLoaded(users: users,
                                        currentPage: current,
                                        nextPage: next,
                                        previousPage: previous)
                }
        }
        
    }
}
