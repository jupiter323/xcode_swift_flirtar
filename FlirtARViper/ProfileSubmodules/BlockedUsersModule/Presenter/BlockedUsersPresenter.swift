//
//  BlockedUsersPresenter.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class BlockedUsersPresenter: BlockedUsersPresenterProtocol {
    weak var view: BlockedUsersViewProtocol?
    var wireframe: BlockedUsersWireframeProtocol?
    var interactor: BlockedUsersInteractorInputProtocol?
    
    fileprivate var userId: Int?
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        interactor?.startLoadBlockedUsers()
    }
    
    func unblockUser() {
        
        if userId != nil {
            view?.showActivityIndicator()
            interactor?.startUnblockUser(withId: userId!)
        }
    }
    
    func loadMoreUsers() {
        interactor?.startLoadMoreUsers()
    }
    
    func unblockCancel() {
        self.userId = nil
    }
    func showUnblockUserAlert(userId: Int) {
        self.userId = userId
        view?.showUnblockUserAlert()
    }
    
    func dismiss() {
        wireframe?.routeBack(fromView: view!)
    }
}

extension BlockedUsersPresenter: BlockedUsersInteractorOutputProtocol {
    func usersLoaded(users: [ShortUser]) {
        view?.hideActivityIndicator()
        view?.showBlockedUsers(users: users)
    }
    
    func moreUserLoaded(users: [ShortUser]) {
        view?.hideActivityIndicator()
        view?.appendMoreUsers(users: users)
    }
    
    func userUnblocked() {
        view?.hideActivityIndicator()
        view?.userUnblocked()
    }
    
    func requestError(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? PhotosUploadError) != nil  {
            errorText = (error as! PhotosUploadError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
        
        
    }
}







