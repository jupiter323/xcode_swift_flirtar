//
//  MessagesLikesPresenter.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class MessagesLikesPresenter: MessagesLikesPresenterProtocol {
    weak var view: MessagesLikesViewProtocol?
    var wireframe: MessagesLikesWireframeProtocol?
    var interactor: MessagesLikesInteractorInputProtocol?
    
    func reloadData() {
        interactor?.startGettingLikes()
    }
    
    func loadMoreLikes() {
        interactor?.startLoadMoreLikes()
    }
    
    func openProfile(withUser user: ShortUser) {
        wireframe?.showFullInfo(fromView: view!,
                                withUser: user)
    }
    
}

extension MessagesLikesPresenter: MessagesLikesInteractorOutputProtocol {
    func didLikesRecived(likes: [ShortUser]) {
        view?.showLikes(likes: likes)
    }
    
    func appendLikesRecieved(likes: [ShortUser]) {
        view?.appendMoreLikes(likes: likes)
    }
}
