//
//  ARProfileRemoteDatamanager.swift
//  FlirtARViper
//
//  Created on 14.08.17.
//

import Foundation
import Alamofire
import SwiftyJSON

class ARProfileRemoteDatamanager: ARProfileRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:ARProfileRemoteDatamanagerOutputProtocol?
    
    func requestUserFromServer(withUserId userId: Int) {
        
        let request = APIRouter.getUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.userRecieveError(method: APIMethod.getProfile, error: GetProfileError.profileLoadingError)
                } else {
                    let user = APIParser().parseShortUser(js: js!)
                    
                    if user != nil {
                        self.remoteRequestHandler?.userRecieved(user: user!)
                    } else {
                        self.remoteRequestHandler?.userRecieveError(method: APIMethod.getProfile, error: GetProfileError.profileResponseError)
                    }
                }
        }
        
        
        
    }
    
    
    func requestLikeUser(withUserId userId: Int) {
        let request = APIRouter.likeUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileChangingLikeStatus(method: APIMethod.setLike, error: LikeError.likeNotSet)
                } else {
                    self.remoteRequestHandler?.likeStatusChanged(newValue: true)
                }
        }
        
        
        
    }
    
    func requestDislikeUser(withUserId userId: Int) {
        let request = APIRouter.dislikeUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileChangingLikeStatus(method: APIMethod.setLike, error: LikeError.unlikeNotSet)
                } else {
                    self.remoteRequestHandler?.likeStatusChanged(newValue: false)
                }
        }
        
    }
    
    func requestUnlikeUser(withUserId userId: Int) {
        let request = APIRouter.unlikeUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileChangingLikeStatus(method: APIMethod.setLike, error: LikeError.unlikeNotSet)
                } else {
                    self.remoteRequestHandler?.likeStatusChanged(newValue: false)
                }
        }
        
    }
    
    
    func requestBlockUser(forUser userId: Int) {
        let request = APIRouter.blockUser(userId: userId)
        
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileBanUser(method: APIMethod.putBlockUser, error: BanUserError.userNotBlocked)
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
                    self.remoteRequestHandler?.errorWhileBanUser(method: APIMethod.reportUser, error: BanUserError.userNotReported)
                } else {
                    self.remoteRequestHandler?.userReported()
                }
        }
        
    }
    
}
