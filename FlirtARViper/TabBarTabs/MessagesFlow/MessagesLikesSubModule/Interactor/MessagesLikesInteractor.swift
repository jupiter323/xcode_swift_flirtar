//
//  MessagesLikesInteractor.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class MessagesLikesInteractor: MessagesLikesInteractorInputProtocol {
    weak var presenter: MessagesLikesInteractorOutputProtocol?
    var remoteDatamanager: MessagesLikesRemoteDatamanagerInputProtocol?
    
    func startGettingLikes() {
        remoteDatamanager?.requestUserLikes()
    }
}

extension MessagesLikesInteractor: MessagesLikesRemoteDatamanagerOutputProtocol {
    func likesRecieved(likes: [ShortUser]) {
        presenter?.didLikesRecived(likes: likes)
    }
    
    func errorWhileRecievingLikes() {
        presenter?.didLikesRecived(likes: [ShortUser]())
    }
}
