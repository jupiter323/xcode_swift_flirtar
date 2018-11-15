//
//  ARShortProfilePresenter.swift
//  FlirtARViper
//
//  Created by on 16.08.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

enum ARProfileButton {
    case next
    case previous
}

class ARShortProfilePresenter: ARShortProfilePresenterProtocol {
    
    //MARK: - Variables
    fileprivate var selectedUser: ShortUser?
    fileprivate var currentIndex = 0 //selected marker always first (from ARTabPresenter)
    fileprivate var lastButtonTapped: ARProfileButton?
    
    //MARK: - ARShortProfilePresenterProtocol
    weak var view: ARShortProfileViewProtocol?
    var wireframe: ARShortProfileWireframeProtocol?
    var interactor: ARShortProfileInteractorInputProtocol?
    
    var markers: [Marker]?
    
    
    
    func viewWillAppear() {
        
        guard let inputMarkers = markers else {
            return
        }
        
        
        if currentIndex >= 0 && currentIndex <= (inputMarkers.count - 1) {
            guard let userId = inputMarkers[currentIndex].user?.id else {
                return
            }
            
            view?.showActivityIndicator()
            interactor?.startGettingInfo(forUser: userId)
        }
        
        if inputMarkers.count == 0 || inputMarkers.count == 1 {
            view?.hideButtons(buttons: [.next, .previous])
        } else if currentIndex == 0 {
            view?.hideButtons(buttons: [.previous])
            view?.showButtons(buttons: [.next])
        } else if currentIndex == (inputMarkers.count - 1) {
            view?.hideButtons(buttons: [.next])
            view?.showButtons(buttons: [.previous])
        } else {
            view?.showButtons(buttons: [.next, .previous])
        }
        
    }
    
    func startSetLike() {
        if let userId = selectedUser?.id,
            let isLiked = selectedUser?.isLiked {
            view?.showActivityIndicator()
            interactor?.startChangingStatus(forUser: userId, status: isLiked)
        }
    }
    
    func showNextUser() {
        lastButtonTapped = .next
        
        
        guard let inputMarkers = markers else {
            return
        }
        
        //check range and count
        if inputMarkers.count != 0 && (currentIndex + 1) < inputMarkers.count && (currentIndex + 1) >= 0 {
            currentIndex += 1
            if let userId = inputMarkers[currentIndex].user?.id {
                view?.showActivityIndicator()
                interactor?.startGettingInfo(forUser: userId)
            }
        }
        
    }
    
    func showPreviousUser() {
        lastButtonTapped = .previous
        
        guard let inputMarkers = markers else {
            return
        }
        
        //check range and count
        if inputMarkers.count != 0 && (currentIndex - 1) < inputMarkers.count && (currentIndex - 1) >= 0 {
            currentIndex -= 1
            if let userId = inputMarkers[currentIndex].user?.id {
                view?.showActivityIndicator()
                interactor?.startGettingInfo(forUser: userId)
            }
        }
    }
    
    func showFullInfo() {
        guard let currentUser = selectedUser else {
            return
        }
        wireframe?.showFullInfo(fromView: view!,
                                withUser: currentUser)
    }
    
}

//MARK: - ARShortProfileInteractorOutputProtocol
extension ARShortProfilePresenter: ARShortProfileInteractorOutputProtocol {
    
    func didLikeMarkSet() {
        view?.hideActivityIndicator()
        guard let currentLikeStatus = selectedUser?.isLiked  else {
            return
        }
        selectedUser?.isLiked = !currentLikeStatus
        view?.likeStatusChanged()
        
    }
    
    func likeMarkNotSet() {
        view?.hideActivityIndicator()
        view?.showError(errorMessage: "Like not set")
    }
    
    func didProfileRecived(profile: ShortUser) {
        selectedUser = profile
        view?.hideActivityIndicator()
        view?.showShortProfile(profile: profile)
        
        guard let inputMarkers = markers else {
            return
        }
        
        if inputMarkers.count > 1 {
            if currentIndex == (inputMarkers.count - 1) {
                view?.hideButtons(buttons: [.next])
                view?.showButtons(buttons: [.previous])
            } else if currentIndex == 0 {
                view?.hideButtons(buttons: [.previous])
                view?.showButtons(buttons: [.next])
            } else {
                view?.showButtons(buttons: [.next, .previous])
            }
        } else {
            view?.hideButtons(buttons: [.next, .previous])
        }
    }
    
    func profileRecieveError(errorMessage: String) {
        if let previousButton = lastButtonTapped {
            switch previousButton {
            case .next:
                currentIndex -= 1
            case .previous:
                currentIndex += 1
            }
        }
        
        view?.hideActivityIndicator()
        view?.showError(errorMessage: errorMessage)
    }
}








