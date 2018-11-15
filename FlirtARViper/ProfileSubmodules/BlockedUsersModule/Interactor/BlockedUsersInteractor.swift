//
//  BlockedUsersInteractor.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class BlockedUsersInteractor: BlockedUsersInteractorInputProtocol {
   
    //MARK: - Variables
    fileprivate var currentPage: Int?
    fileprivate var previousPage: Int?
    fileprivate var nextPage: Int?
    
    
    //MARK: - BlockedUsersInteractorInputProtocol
    weak var presenter: BlockedUsersInteractorOutputProtocol?
    var remoteDatamanager: BlockedUsersRemoteDatamanagerInputProtocol?
    
    func startLoadBlockedUsers() {
        currentPage = nil
        previousPage = nil
        nextPage = nil
        remoteDatamanager?.requestLoadUsers()
    }
    
    func startLoadMoreUsers() {
        guard let next = nextPage else {
            return
        }
        
        remoteDatamanager?.requestLoadMoreUsers(page: next)
    }
    
    func startUnblockUser(withId userId: Int) {
        remoteDatamanager?.requestUnblockUser(withId: userId)
    }
}

extension BlockedUsersInteractor: BlockedUsersRemoteDatamanagerOutputProtocol {
    
    func usersLoaded(users: [ShortUser],
                     currentPage: Int?,
                     nextPage: Int?,
                     previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        presenter?.usersLoaded(users: users)
    }
    
    func moreUserLoaded(users: [ShortUser],
                        currentPage: Int?,
                        nextPage: Int?,
                        previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        presenter?.moreUserLoaded(users: users)
    }
    
    func userUnblocked() {
        presenter?.userUnblocked()
    }
    
    func requestError(method: APIMethod, error: Error) {
        presenter?.requestError(method: method, error: error)
    }
}
