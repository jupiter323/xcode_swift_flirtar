//
//  InstagramPhotosProtocols.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

protocol InstagramPhotosViewProtocol: class {
    
    var presenter: InstagramPhotosPresenterProtocol? {get set}
    
    func showRequestError(method: String, errorMessage: String)
    
    func showPhotos(photos: [Photo])
    func showConnectButton()
    
}

protocol InstagramPhotosWireframeProtocol {
    static func configureInstagramPhotosView(withUser userId: Int?) -> UIViewController
    func routeToInstagramAuth(fromView view: InstagramPhotosViewProtocol)
}

protocol InstagramPhotosPresenterProtocol {
    var view: InstagramPhotosViewProtocol? {get set}
    var wireframe: InstagramPhotosWireframeProtocol? {get set}
    var interactor: InstagramPhotosInteractorInputProtocol? {get set}
    
    func reloadPhotos()
    func showInstagramAuth()
    
    func instagramConnection(withToken token: String)
    
}

protocol InstagramPhotosInteractorInputProtocol {
    var presenter: InstagramPhotosInteractorOutputProtocol? {get set}
    var remoteDatamanager: InstagramPhotosRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: InstagramPhotosLocalDatamanagerInputProtocol? {get set}
    func startGettingInstagramPhotos(userId: Int)
    
    func startInstagramConnection(withToken token: String)
    
}

protocol InstagramPhotosInteractorOutputProtocol: class {
    func didRecievePhotos(photos: [Photo])

    func requestError(method: APIMethod, error: Error)
    
}

protocol InstagramPhotosRemoteDatamanagerOutputProtocol: class {
    func photosRecieved(photos: [Photo])
    
    func instagramConnected()
    func requestError(method: APIMethod, error: Error)
}


protocol InstagramPhotosRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:InstagramPhotosRemoteDatamanagerOutputProtocol? {get set}
    func requestInstagramPhotos(userId: Int)
    func requestInstagramConnection(withToken token: String)
    
}


protocol InstagramPhotosLocalDatamanagerInputProtocol: class {
    func saveInstagramStatus(userId: Int, status: Bool) throws
}
