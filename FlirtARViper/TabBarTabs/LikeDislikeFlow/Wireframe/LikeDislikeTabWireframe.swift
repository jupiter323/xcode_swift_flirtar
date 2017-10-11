//
//  LikeDislikeTabWireframe.swift
//  FlirtARViper
//
//  Created by on 03.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class LikeDislikeTabWireframe: LikeDislikeTabWireframeProtocol {
    static func configureLikeDislikeTabView() -> UIViewController {
        
        let likeController = UIStoryboard(name: "LikeDislikeTab", bundle: nil).instantiateViewController(withIdentifier: "LikeDislikeTabViewController")
        
        if let view = likeController as? LikeDislikeTabViewController {
            
            let presenter = LikeDislikeTabPresenter()
            let interactor = LikeDislikeTabInteractor()
            let wireframe = LikeDislikeTabWireframe()
            let remoteDatamanager = LikeDislikeTabRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return likeController
            
        }
        return UIViewController()
        
        
    }
    
    func showFullInfo(fromView view: LikeDislikeTabViewProtocol,
                      withUser user: ShortUser) {
        let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUser: user)
        if let sourceView = view as? UIViewController {
            sourceView.present(arProfileDetailController,
                               animated: true,
                               completion: nil)
        }
    }
}
