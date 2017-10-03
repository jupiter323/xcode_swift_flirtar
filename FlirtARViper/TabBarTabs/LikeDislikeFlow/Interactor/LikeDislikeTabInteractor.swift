//
//  LikeDislikeTabInteractor.swift
//  FlirtARViper
//
//  Created by on 03.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class LikeDislikeTabInteractor: LikeDislikeTabInteractorInputProtocol {
    
    //MARK: - Variables
    fileprivate var currentPage: Int?
    fileprivate var previousPage: Int?
    fileprivate var nextPage: Int?
    
    
    //MARK: - LikeDislikeTabInteractorInputProtocol
    weak var presenter: LikeDislikeTabIntercatorOutputProtocol?
    var remoteDatamanager: LikeDislikeTabRemoteDatamanagerInputProtocol?
    
    func startLoadInitialUsers() {
        remoteDatamanager?.requestInitialUsers()
    }
    
    func loadMoreUsers() {
        
        guard let next = nextPage else {
            return
        }
        
        remoteDatamanager?.requestMoreUsers(page: next)
    }
    
    func startSetMark(forUser userId: Int?, mark: Bool) {
        guard let userId = userId else {
            return
        }
        
        if mark {
            remoteDatamanager?.requestSetLike(forUser: userId)
        } else {
            remoteDatamanager?.requestSetDislike(forUser: userId)
        }
        
    }
    
    
    func startReportUser(withText text: String, andUserId userId: Int) {
        remoteDatamanager?.requestReportUser(forUser: userId, reason: text)
    }
    
    func startBlockUser(userId: Int) {
        remoteDatamanager?.requestBlockUser(forUser: userId)
    }
}

//MARK: - LikeDislikeTabRemoteDatamanagerOutputProtocol
extension LikeDislikeTabInteractor: LikeDislikeTabRemoteDatamanagerOutputProtocol {
    
    func usersRecieved(users: [ShortUser],
                       currentPage: Int?,
                       nextPage: Int?,
                       previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        presenter?.usersRecieved(users: users)
        
        
    }
    
    func moreUsersRecieved(users: [ShortUser],
                           currentPage: Int?,
                           nextPage: Int?,
                           previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        presenter?.moreUsersRecieved(users: users)
        
        
    }
    
    func errorWhileLoading(method: APIMethod, error: Error) {
        presenter?.errorWhileLoading(method: method, error: error)
    }
    
    func userBlocked() {
        presenter?.userBlocked()
    }
    
    func userReported() {
        presenter?.userReported()
    }
    
}
