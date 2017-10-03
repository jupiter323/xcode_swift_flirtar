//
//  LoginWireframe.swift
//  FlirtARViper
//
//  Created by   on 01.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class LoginWireframe: LoginWireframeProtocol {
    static func configureLoginView() -> UIViewController {
        
        
        
        let loginController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "loginViewController")
        
        if let view = loginController as? LoginViewController {
            let presenter = LoginPresenter()
            let interactor = LoginInteractor()
            let wireframe = LoginWireframe()
            let remoteDatamanager = LoginRemoteDatamanager()
            let localDatamanager = LoginLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return loginController

        }
        
        return UIViewController()

    }
    
    func backToSplash(fromView view: LoginViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToPasswordRecover(fromView view: LoginViewProtocol) {
        
        let recoverController = RecoverWireframe.configureRecoverView()
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(recoverController, animated: true)
        }
        
    }
    
    func routeToSignUp(fromView view: LoginViewProtocol) {
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
    
    func routeToMainTab(fromView view: LoginViewProtocol) {
        let tabBarController = TabBarWireframe.configureTabBar()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = tabBarController
        appDelegate?.window?.makeKeyAndVisible()
        
    }
}
