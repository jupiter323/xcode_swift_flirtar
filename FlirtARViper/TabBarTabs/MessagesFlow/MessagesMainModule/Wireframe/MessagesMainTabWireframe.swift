//
//  MessagesMainTabWireframe.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class MessagesMainTabWireframe: MessagesMainTabWireframeProtocol {
    static func configureMessagesMainTapView() -> UIViewController {
        let messagesNavigationController = UIStoryboard(name: "MessagesMainTab", bundle: nil).instantiateViewController(withIdentifier: "MessagesMainNavigation")
        
        if let view = messagesNavigationController.childViewControllers.first as? MessagesMainTabViewController {
            
            let presenter = MessagesMainTabPresenter()
            let interactor = MessagesMainTabInteractor()
            let wireframe = MessagesMainTabWireframe()
            let remoteDatamanager = MessagesMainTabRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor

            
            return messagesNavigationController
        }
        
        return UIViewController()
    }
    
    func routeToDetailMessages(fromView view: MessagesMainTabViewProtocol,
                               withDialog dialog: Dialog) {
        let messagesController = MessagesDetailWireframe.configureMessagesDetailView(withDialog: dialog)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(messagesController, animated: true)
        }
    }
}
