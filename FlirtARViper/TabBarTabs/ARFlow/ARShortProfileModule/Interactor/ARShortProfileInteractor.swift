//
//  ARShortProfileInteractor.swift
//  FlirtARViper
//
//  Created by on 16.08.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation


class ARShortProfileInteractor: ARShortProfileInteractorInputProtocol {
    weak var presenter: ARShortProfileInteractorOutputProtocol?
    var remoteDatamanager: ARShortProfileRemoteDatamanagerInputProtocol?
    
    
    func startGettingInfo(forUser userId: Int) {
        remoteDatamanager?.requestUserInfo(withUserId: userId)
    }
    
    func startChangingStatus(forUser userId: Int, status: Bool) {
        if status {
            remoteDatamanager?.requestUnlikeUser(withUserId: userId)
        } else {
            remoteDatamanager?.requestLikeUser(withUserId: userId)
        }
    }
}


extension ARShortProfileInteractor: ARShortProfileRemoteDatamanagerOutputProtocol {
    
    func likeStatusChanged() {
        presenter?.didLikeMarkSet()
    }
    
    func errorWhileChangingLikeStatus(text: String) {
        presenter?.likeMarkNotSet()
    }
    
    func profileRecived(profile: ShortUser) {
        presenter?.didProfileRecived(profile: profile)
    }
    
    func errorWhileRecievingProfile(text: String) {
        presenter?.profileRecieveError(errorMessage: text)
    }
    
    
}



