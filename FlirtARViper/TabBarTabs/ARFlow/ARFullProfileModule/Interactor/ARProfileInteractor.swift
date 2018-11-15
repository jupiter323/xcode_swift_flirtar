//
//  ARProfileInteractor.swift
//  FlirtARViper
//
//  Created on 14.08.17.
//

import Foundation


class ARProfileInteractor: ARProfileInteractorInputProtocol {
    weak var presenter: ARProfileInteractorOutputProtocol?
    var remoteDatamanager: ARProfileRemoteDatamanagerInputProtocol?
    
    func startChangingStatus(forUser userId: Int, status: Bool) {
        if status {
            remoteDatamanager?.requestDislikeUser(withUserId: userId)
        } else {
            remoteDatamanager?.requestLikeUser(withUserId: userId)
        }

    }
    
    func startUnlikeUser(forUser userId: Int) {
        remoteDatamanager?.requestUnlikeUser(withUserId: userId)
    }
    
    func startLoadingUser(userId: Int) {
        remoteDatamanager?.requestUserFromServer(withUserId: userId)
    }
    
    func startReportUser(withText text: String, andUserId userId: Int) {
        remoteDatamanager?.requestReportUser(forUser: userId, reason: text)
    }
    
    func startBlockUser(userId: Int) {
        remoteDatamanager?.requestBlockUser(forUser: userId)
    }
    
}

extension ARProfileInteractor: ARProfileRemoteDatamanagerOutputProtocol {
    
    func userRecieved(user: ShortUser) {
        presenter?.userRecieved(user: user)
    }
    
    func userRecieveError(method: APIMethod, error: Error) {
        presenter?.errorWhileRecievingUser(method: method, error: error)
    }
    
    
    func likeStatusChanged(newValue: Bool) {
        presenter?.didLikeMarkSet(newValue: newValue)
    }
    
    func errorWhileChangingLikeStatus(method: APIMethod, error: Error) {
        presenter?.likeMarkNotSet(method: method, error: error)
    }
    
    func userBlocked() {
        presenter?.userBlocked()
    }
    
    func userReported() {
        presenter?.userReported()
    }
    
    func errorWhileBanUser(method: APIMethod, error: Error) {
        presenter?.errorWhileBanUser(method: method, error: error)
    }
    
}
