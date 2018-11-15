//
//  InstagramPhotosPresenter.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class InstagramPhotosPresenter: InstagramPhotosPresenterProtocol {
    weak var view: InstagramPhotosViewProtocol?
    var wireframe: InstagramPhotosWireframeProtocol?
    var interactor: InstagramPhotosInteractorInputProtocol?
    
    private var userId: Int?
    
    init(userId: Int?) {
        self.userId = userId
    }
    
    func reloadPhotos() {
        //check user Id
        if userId != nil {
            //check current user insta auth
            if let instagramConnected = ProfileService.savedUser?.instagramConnected {
                //if not connected and current user -> show connect button
                if !instagramConnected && userId == ProfileService.savedUser?.userID {
                    view?.showConnectButton()
                    //and return
                    return
                }
            }
            //else get photos
            interactor?.startGettingInstagramPhotos(userId: userId!)
        } else {
            //if nill show empty block
            view?.showPhotos(photos: [])
        }
        
    }
    
    func instagramConnection(withToken token: String) {
        interactor?.startInstagramConnection(withToken: token)
    }
    
    func showInstagramAuth() {
        wireframe?.routeToInstagramAuth(fromView: view!)
    }
}

extension InstagramPhotosPresenter: InstagramPhotosInteractorOutputProtocol {
    func didRecievePhotos(photos: [Photo]) {
        view?.showPhotos(photos: photos)
    }
    
    func requestError(method: APIMethod, error: Error) {
        view?.showRequestError(method: method.rawValue, errorMessage: error.localizedDescription)
    }
}
