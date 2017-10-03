//
//  BlockedUsersWireframe.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class BlockedUsersWireframe: BlockedUsersWireframeProtocol {
    static func configureBlockedUsersView() -> UIViewController {
        let blockedUsersController = UIStoryboard(name: "BlockedUsers", bundle: nil).instantiateViewController(withIdentifier: "BlockedUsersViewController")
        
        if let view = blockedUsersController as? BlockedUsersViewController {
            
            let presenter = BlockedUsersPresenter()
            let interactor = BlockedUsersInteractor()
            let wireframe = BlockedUsersWireframe()
            let remoteDatamanager = BlockedUsersRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return blockedUsersController
            
        }
        return UIViewController()
    }
    
    
    func routeBack(fromView view: BlockedUsersViewProtocol) {
        if let sourceView = view as? BlockedUsersViewController {
            sourceView.dismiss(animated: true, completion: nil)
        }
    }
}
