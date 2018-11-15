//
//  MessagesLikesInteractor.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class MessagesLikesInteractor: MessagesLikesInteractorInputProtocol {
   
    //MARK: - Variables
    fileprivate var currentPage: Int?
    fileprivate var previousPage: Int?
    fileprivate var nextPage: Int?
    
    //MARK: - MessagesLikesInteractorInputProtocol
    weak var presenter: MessagesLikesInteractorOutputProtocol?
    var remoteDatamanager: MessagesLikesRemoteDatamanagerInputProtocol?
    
    func startGettingLikes() {
        currentPage = nil
        previousPage = nil
        nextPage = nil
        remoteDatamanager?.requestUserLikes()
    }
    
    func startLoadMoreLikes() {
        guard let next = nextPage else {
            return
        }
        remoteDatamanager?.requestMoreUserLikes(page: next)
    }
}

extension MessagesLikesInteractor: MessagesLikesRemoteDatamanagerOutputProtocol {
    func likesRecieved(likes: [ShortUser],
                       currentPage: Int?,
                       nextPage: Int?,
                       previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        presenter?.didLikesRecived(likes: likes)
    }
    
    func appendLikesRecieved(likes: [ShortUser],
                                currentPage: Int?,
                                nextPage: Int?,
                                previousPage: Int?) {
        
        self.currentPage = currentPage
        self.nextPage = nextPage
        self.previousPage = previousPage
        
        presenter?.appendLikesRecieved(likes: likes)
        
    }
    
    
    func errorWhileRecievingLikes() {
        presenter?.didLikesRecived(likes: [ShortUser]())
    }
}
