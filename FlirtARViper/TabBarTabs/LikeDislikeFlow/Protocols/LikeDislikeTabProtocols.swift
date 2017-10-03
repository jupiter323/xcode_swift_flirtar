//
//  LikeDislikeProtocols.swift
//  FlirtARViper
//
//  Created on 03.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit


protocol LikeDislikeTabViewProtocol: class {
    
    var presenter: LikeDislikeTabPresenterProtocol? {get set}
    
    func showUsers(users: [ShortUser])
    func appendUsers(newUsers: [ShortUser])
    func showActivityIndicator()
    func hideActivityIndicator()
    func showError(method: String, errorMessage: String)
    
    func showUserBlocked()
    func showUserReported()
    
}

protocol LikeDislikeTabWireframeProtocol {
    static func configureLikeDislikeTabView() -> UIViewController
}

protocol LikeDislikeTabPresenterProtocol {
    var view: LikeDislikeTabViewProtocol? {get set}
    var wireframe: LikeDislikeTabWireframeProtocol? {get set}
    var interactor: LikeDislikeTabInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    func loadMoreUsers()
    
    func setMark(forUser userId: Int?,
                 mark: Bool)
    
    func reportUser(withText: String, andUserId userId: Int)
    func blockUser(userId: Int)
    
}

protocol LikeDislikeTabInteractorInputProtocol {
    var presenter: LikeDislikeTabIntercatorOutputProtocol? {get set}
    var remoteDatamanager: LikeDislikeTabRemoteDatamanagerInputProtocol? {get set}
    
    func startLoadInitialUsers()
    func loadMoreUsers()
    func startSetMark(forUser userId: Int?, mark: Bool)
    
    func startReportUser(withText text: String, andUserId userId: Int)
    func startBlockUser(userId: Int)
    
}

protocol LikeDislikeTabIntercatorOutputProtocol: class {
    func usersRecieved(users: [ShortUser])
    func moreUsersRecieved(users: [ShortUser])
    func errorWhileLoading(method: APIMethod, error: Error)
    
    func userBlocked()
    func userReported()
}

protocol LikeDislikeTabRemoteDatamanagerOutputProtocol: class {
    func usersRecieved(users: [ShortUser],
                       currentPage: Int?,
                       nextPage: Int?,
                       previousPage: Int?)
    
    func moreUsersRecieved(users: [ShortUser],
                           currentPage: Int?,
                           nextPage: Int?,
                           previousPage: Int?)
    
    func errorWhileLoading(method: APIMethod, error: Error)
    
    func userBlocked()
    func userReported()
    
}


protocol LikeDislikeTabRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:LikeDislikeTabRemoteDatamanagerOutputProtocol? {get set}
    func requestInitialUsers()
    func requestSetLike(forUser userId: Int)
    func requestSetDislike(forUser userId: Int)
    func requestMoreUsers(page: Int)
    
    func requestReportUser(forUser userId: Int, reason: String)
    func requestBlockUser(forUser userId: Int)
}
