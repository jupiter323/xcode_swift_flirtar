//
//  RecoverWireframe.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class RecoverWireframe: RecoveryWireframeProtocol {
    
    static func configureRecoverView() -> UIViewController {
        
        
        let recoverController = UIStoryboard(name: "Recover", bundle: nil).instantiateViewController(withIdentifier: "recoverViewController")
        
        if let view = recoverController as? RecoverViewController {
            let presenter = RecoverPresenter()
            let interactor = RecoverInteractor()
            let wireframe = RecoverWireframe()
            let remoteDatamanager = RecoverRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return recoverController
            
        }
        
        return UIViewController()
    }
    
    func backToLogin(fromView view: RecoveryViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToSignUp(fromView view: RecoveryViewProtocol) {
        let signUpController = SUEmailWireframe.configureSUEmailView()
        
        if let sourceView = view as? UIViewController {
            guard let controllersInStack = sourceView.navigationController?.childViewControllers.count else {
                return
            }
            
            if controllersInStack == 1 {
                sourceView.navigationController?.pushViewController(signUpController, animated: true)
            } else if controllersInStack > 1 {
                sourceView.navigationController?.replaceViewControllers(last: controllersInStack - 1, to: [signUpController])
            }
        }
    }

}
