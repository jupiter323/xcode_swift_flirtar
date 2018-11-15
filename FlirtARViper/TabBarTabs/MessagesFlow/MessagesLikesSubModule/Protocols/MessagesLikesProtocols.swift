//
//  MessagesLikesProtocols.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

protocol MessagesLikesViewProtocol: class {
    var presenter: MessagesLikesPresenterProtocol? {get set}
    
    func showLikes(likes: [ShortUser])
    func appendMoreLikes(likes: [ShortUser])
    
}

protocol MessagesLikesWireframeProtocol {
    static func configureMessagesLikesView() -> UIViewController
    
    func showFullInfo(fromView view: MessagesLikesViewProtocol,
                      withUser user: ShortUser)
}

protocol MessagesLikesPresenterProtocol {
    var view: MessagesLikesViewProtocol? {get set}
    var wireframe: MessagesLikesWireframeProtocol? {get set}
    var interactor: MessagesLikesInteractorInputProtocol? {get set}
    
    func reloadData()
    func loadMoreLikes()
    func openProfile(withUser user: ShortUser)
    
}

protocol MessagesLikesInteractorInputProtocol {
    var presenter: MessagesLikesInteractorOutputProtocol? {get set}
    var remoteDatamanager: MessagesLikesRemoteDatamanagerInputProtocol? {get set}
    
    func startGettingLikes()
    func startLoadMoreLikes()
}

protocol MessagesLikesInteractorOutputProtocol: class {
    func didLikesRecived(likes: [ShortUser])
    func appendLikesRecieved(likes: [ShortUser])
}

protocol MessagesLikesRemoteDatamanagerOutputProtocol: class {
    func likesRecieved(likes: [ShortUser],
                       currentPage: Int?,
                       nextPage: Int?,
                       previousPage: Int?)
    
    func appendLikesRecieved(likes: [ShortUser],
                                currentPage: Int?,
                                nextPage: Int?,
                                previousPage: Int?)
    
    func errorWhileRecievingLikes()
}

protocol MessagesLikesRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:MessagesLikesRemoteDatamanagerOutputProtocol? {get set}
    func requestUserLikes()
    func requestMoreUserLikes(page: Int)
}





