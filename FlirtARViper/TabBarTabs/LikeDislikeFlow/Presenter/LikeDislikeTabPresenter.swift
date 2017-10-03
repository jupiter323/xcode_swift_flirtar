//
//  LikeDislikeTabPresenter.swift
//  FlirtARViper
//
//  Created by on 03.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class LikeDislikeTabPresenter: LikeDislikeTabPresenterProtocol {
    
    weak var view: LikeDislikeTabViewProtocol?
    var wireframe: LikeDislikeTabWireframeProtocol?
    var interactor: LikeDislikeTabInteractorInputProtocol?
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        interactor?.startLoadInitialUsers()
    }
    
    
    func loadMoreUsers() {
        interactor?.loadMoreUsers()
    }
    
    func setMark(forUser userId: Int?,
                 mark: Bool) {
        
        interactor?.startSetMark(forUser: userId, mark: mark)
        
    }
    
    func reportUser(withText: String, andUserId userId: Int) {
        view?.showActivityIndicator()
        interactor?.startReportUser(withText: withText, andUserId: userId)
    }
    
    func blockUser(userId: Int) {
        view?.showActivityIndicator()
        interactor?.startBlockUser(userId: userId)
    }
    

    
}

extension LikeDislikeTabPresenter: LikeDislikeTabIntercatorOutputProtocol {
    
    func usersRecieved(users: [ShortUser]) {
        view?.hideActivityIndicator()
        view?.showUsers(users: users)
    }
    
    func moreUsersRecieved(users: [ShortUser]) {
        view?.appendUsers(newUsers: users)
    }
    
    func errorWhileLoading(method: APIMethod, error: Error) {
        
        
        var errorText = ""
        if (error as? GetMatchUsersError) != nil  {
            errorText = (error as! GetMatchUsersError).localizedDescription
        } else if (error as? BanUserError) != nil {
            errorText = (error as! BanUserError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.hideActivityIndicator()
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
    func userBlocked() {
        view?.hideActivityIndicator()
        view?.showUserBlocked()
    }
    
    func userReported() {
        view?.hideActivityIndicator()
        view?.showUserReported()
    }
    
}
