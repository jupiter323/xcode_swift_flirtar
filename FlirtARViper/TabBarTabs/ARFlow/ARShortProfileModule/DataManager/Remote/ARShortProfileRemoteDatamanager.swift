//
//  ARShortProfileRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by Daniel Harold on 16.08.17.
//  Copyright © 2017 Daniel Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ARShortProfileRemoteDatamanager: ARShortProfileRemoteDatamanagerInputProtocol {
    

    weak var remoteRequestHandler:ARShortProfileRemoteDatamanagerOutputProtocol?
    
    func requestUserInfo(withUserId userId: Int) {
        let request = APIRouter.getUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.errorWhileRecievingProfile(text: error!.localizedDescription)
            } else {
                if js!.dictionaryObject != nil {
                    var profile = ShortUser(JSON: js!.dictionaryObject!)
                    
                    let jsArray = js!["photos"].array
                    guard let jsPhotoArray = jsArray else {
                        return
                    }
                    for eachPhoto in jsPhotoArray {
                        if let photoDictionary = eachPhoto.dictionaryObject {
                            let photo = Photo(JSON: photoDictionary)
                            if photo != nil {
                                profile?.photos.append(photo!)
                            }
                        }
                    }
                    
                    if profile != nil {
                        self.remoteRequestHandler?.profileRecived(profile: profile!)
                    } else {
                        self.remoteRequestHandler?.errorWhileRecievingProfile(text: "Profile parsing error")
                    }
                } else {
                    self.remoteRequestHandler?.errorWhileRecievingProfile(text: "Profile loading error")
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
                    self.remoteRequestHandler?.errorWhileChangingLikeStatus(text: error!.localizedDescription)
                } else {
                    self.remoteRequestHandler?.likeStatusChanged()
                }
        }
        
    }
    
    func requestUnlikeUser(withUserId userId: Int) {
        let request = APIRouter.unlikeUser(userId: userId)
        
        NetworkManager
            .shared
            .sendAPIRequestWithStringResponse(request: request) { (error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileChangingLikeStatus(text: error!.localizedDescription)
                } else {
                    self.remoteRequestHandler?.likeStatusChanged()
                }
        }
        
    }
}
