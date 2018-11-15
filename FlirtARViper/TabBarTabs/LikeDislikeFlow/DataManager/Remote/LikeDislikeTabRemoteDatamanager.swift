//
//  LikeDislikeTabRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by on 03.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LikeDislikeTabRemoteDatamanager: LikeDislikeTabRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:LikeDislikeTabRemoteDatamanagerOutputProtocol?
    
    func requestInitialUsers() {
        let request = APIRouter.getMatchUsers(page: nil)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileLoading(method: .getMatchUsers, error: GetMatchUsersError.usersNotRecieved)
                } else {
                    
                    let previous = js!["previous"].int
                    let current = js!["current"].int
                    let next = js!["next"].int
                    
                    let users = APIParser().parseShortUsers(js: js!["results"])
                    
                    self.remoteRequestHandler?.usersRecieved(users: users,
                                                             currentPage: current,
                                                             nextPage: next,
                                                             previousPage: previous)
                }
        }
        
        
    }
    
    func requestSetLike(forUser userId: Int) {
        let request = APIRouter.likeUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
        }
        
    }
    
    func requestSetDislike(forUser userId: Int) {
        
        let request = APIRouter.dislikeUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
        }
        
    }
    
    func requestMoreUsers(page: Int) {
        
        
        let request = APIRouter.getMatchUsers(page: page)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, _) in
                if js != nil {
                    let previous = js!["previous"].int
                    let current = js!["current"].int
                    let next = js!["next"].int
                    let users = APIParser().parseShortUsers(js: js!["results"])
                    
                    
                    self.remoteRequestHandler?.moreUsersRecieved(users: users,
                                                                 currentPage: current,
                                                                 nextPage: next,
                                                                 previousPage: previous)
                }
        }
        
    }
    
    func requestBlockUser(forUser userId: Int) {
        let request = APIRouter.blockUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileLoading(method: APIMethod.putBlockUser, error: BanUserError.userNotBlocked)
                } else {
                    self.remoteRequestHandler?.userBlocked()
                }
        }
        
    }
    
    func requestReportUser(forUser userId: Int, reason: String) {
        let request = APIRouter.reportUser(userId: userId, reportString: reason)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileLoading(method: APIMethod.reportUser, error: BanUserError.userNotReported)
                } else {
                    self.remoteRequestHandler?.userReported()
                }
        }
        
    }
    
    
}
