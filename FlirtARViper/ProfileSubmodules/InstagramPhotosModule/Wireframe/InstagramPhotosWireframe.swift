//
//  InstagramPhotosWireframe.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class InstagramPhotosWireframe: InstagramPhotosWireframeProtocol {
    static func configureInstagramPhotosView(withUser userId: Int?) -> UIViewController {
        
        let instagramPhotosController = UIStoryboard(name: "InstagramPhotos", bundle: nil).instantiateViewController(withIdentifier: "InstagramPhotosViewController")
        
        if let view = instagramPhotosController as? InstagramPhotosViewController {
            
            
            let presenter = InstagramPhotosPresenter(userId: userId)
            let interactor = InstagramPhotosInteractor()
            let wireframe = InstagramPhotosWireframe()
            let remoteDatamanager = InstagramPhotosRemoteDatamanager()
            let localDatamanager = InstagramPhotosLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return instagramPhotosController
            
        }
        return UIViewController()
    }
    
    func routeToInstagramAuth(fromView view: InstagramPhotosViewProtocol) {
        let instagramAuthController = UIStoryboard(name: "InstagramAuth", bundle: nil).instantiateViewController(withIdentifier: "InstagramAuthViewController")
        
        if let sourceView = view as? InstagramPhotosViewController {
            if instagramAuthController is InstagramAuthViewController {
                (instagramAuthController as! InstagramAuthViewController).delegate = sourceView
                sourceView.present(instagramAuthController, animated: true, completion: nil)
            }
        }
    }
}
