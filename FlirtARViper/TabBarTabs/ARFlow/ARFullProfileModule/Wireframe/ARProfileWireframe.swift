//
//  ARProfileWireframe.swift
//  FlirtARViper
//
//  Created by   on 12.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class ARProfileWireframe: ARProfileWireframeProtocol {
    
    static func configureARFullProfileView(withUser user: ShortUser) -> UIViewController {
        let arProfileController = UIStoryboard(name: "ARProfile", bundle: nil).instantiateViewController(withIdentifier: "ARProfileViewController")
        
        if let view = arProfileController as? ARProfileViewController {
            
            view.modalTransitionStyle = .crossDissolve
            view.modalPresentationStyle = .custom
            
            let presenter = ARProfilePresenter()
            let interactor = ARProfileInteractor()
            let wireframe = ARProfileWireframe()
            let remoteDatamanager = ARProfileRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            presenter.selectedUser = user
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return arProfileController
            
        }
        return UIViewController()
    }
    
    static func configureARFullProfileView(withUserId userId: Int) -> UIViewController {
        let arProfileController = UIStoryboard(name: "ARProfile", bundle: nil).instantiateViewController(withIdentifier: "ARProfileViewController")
        
        if let view = arProfileController as? ARProfileViewController {
            
            view.modalTransitionStyle = .crossDissolve
            view.modalPresentationStyle = .custom
            
            let presenter = ARProfilePresenter()
            let interactor = ARProfileInteractor()
            let wireframe = ARProfileWireframe()
            let remoteDatamanager = ARProfileRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            presenter.selectedUserId = userId
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return arProfileController
            
        }
        return UIViewController()
    }
    
    func backToMainAR(fromView view: ARProfileViewProtocol) {
        if let sourceView = view as? UIViewController {
            if sourceView.navigationController != nil {
                let _ = sourceView.navigationController?.popViewController(animated: true)
            } else {
                sourceView.removeFromParentViewController()
                sourceView.dismiss(animated: true, completion: nil)
                
            }
        }
    }
}
