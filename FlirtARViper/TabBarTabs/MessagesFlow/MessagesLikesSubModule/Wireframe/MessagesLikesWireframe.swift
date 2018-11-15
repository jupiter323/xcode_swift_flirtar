//
//  MessagesLikesWireframe.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class MessagesLikesWireframe: MessagesLikesWireframeProtocol {
    static func configureMessagesLikesView() -> UIViewController {
        
        let messagesLikesController = UIStoryboard(name: "MessagesLikes", bundle: nil).instantiateViewController(withIdentifier: "MessagesLikesViewController")
        
        if let view = messagesLikesController as? MessagesLikesViewController {
            
            let presenter = MessagesLikesPresenter()
            let interactor = MessagesLikesInteractor()
            let wireframe = MessagesLikesWireframe()
            let remoteDatamanager = MessagesLikesRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return messagesLikesController
            
        }
        return UIViewController()
    }
    
    func showFullInfo(fromView view: MessagesLikesViewProtocol, withUser user: ShortUser) {
        let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUser: user) as? ARProfileViewController
        arProfileDetailController?.delegate = view as? MessagesLikesViewController
        if let sourceView = view as? UIViewController {
            if arProfileDetailController != nil {
                sourceView.present(arProfileDetailController!,
                                   animated: true,
                                   completion: nil)
            }
        }
    }
    
    
}
