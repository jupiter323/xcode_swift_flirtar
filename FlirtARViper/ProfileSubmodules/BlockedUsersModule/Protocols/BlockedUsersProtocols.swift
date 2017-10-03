//
//  BlockedUsersProtocols.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol BlockedUsersViewProtocol: class {
    var presenter: BlockedUsersPresenterProtocol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    
    func showUnblockUserAlert()
    func hideUnblockUserAlert()
    
    func showError(method: String, errorMessage: String)
    func showBlockedUsers(users: [MarkerUser])
    func appendMoreUsers(users: [MarkerUser])
    
    func userUnblocked()
    
}

protocol BlockedUsersWireframeProtocol {
    static func configureBlockedUsersView() -> UIViewController
    func routeBack(fromView view: BlockedUsersViewProtocol)
}

protocol BlockedUsersPresenterProtocol {
    weak var view: BlockedUsersViewProtocol? {get set}
    var wireframe: BlockedUsersWireframeProtocol? {get set}
    var interactor: BlockedUsersInteractorInputProtocol? {get set}
    
    func viewDidLoad()
    func unblockUser()
    func loadMoreUsers()
    
    func unblockCancel()
    func showUnblockUserAlert(userId: Int)
    
    func dismiss()
    
    
    
}

protocol BlockedUsersInteractorInputProtocol {
    weak var presenter: BlockedUsersInteractorOutputProtocol? {get set}
    var remoteDatamanager: BlockedUsersRemoteDatamanagerInputProtocol? {get set}
    
    func startLoadBlockedUsers()
    func startLoadMoreUsers()
    func startUnblockUser(withId userId: Int)
    
    
}

protocol BlockedUsersInteractorOutputProtocol: class {
    func usersLoaded(users: [MarkerUser])
    func moreUserLoaded(users: [MarkerUser])
    func userUnblocked()
    func requestError(method: APIMethod, error: Error)
    
}

protocol BlockedUsersRemoteDatamanagerOutputProtocol: class {
    func usersLoaded(users: [MarkerUser],
                     currentPage: Int?,
                     nextPage: Int?,
                     previousPage: Int?)

    func moreUserLoaded(users: [MarkerUser],
                        currentPage: Int?,
                        nextPage: Int?,
                        previousPage: Int?)
    
    func userUnblocked()
    func requestError(method: APIMethod, error: Error)
    
}


protocol BlockedUsersRemoteDatamanagerInputProtocol: class {
    weak var remoteRequestHandler:BlockedUsersRemoteDatamanagerOutputProtocol? {get set}
    
    func requestUnblockUser(withId userId: Int)
    func requestLoadUsers()
    func requestLoadMoreUsers(page: Int)
}
