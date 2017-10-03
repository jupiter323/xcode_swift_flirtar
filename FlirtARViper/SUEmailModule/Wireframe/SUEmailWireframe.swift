//
//  SUEmailWireframe.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUEmailWireframe: SUEmailWireframeProtocol {
    
    static func configureSUEmailView() -> UIViewController {
        let signUpController = UIStoryboard(name: "SUEmail", bundle: nil).instantiateViewController(withIdentifier: "SUEmailViewController")
        
        if let view = signUpController as? SUEmailViewController {
            
            
            let presenter = SUEmailPresenter()
            let interactor = SUEmailInteractor()
            let wireframe = SUEmailWireframe()
            let remoteDatamanager = SUEmailRemoteDatamanager()
            let localDatamanager = SUEmailLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return signUpController
            
        }
        
        return UIViewController()
        
    }
    
    func routeToPinCodeView(fromView view: SUEmailViewProtocol) {
        let pinCodeController = SUPinCodeWireframe.configureSUPinCodeView()
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(pinCodeController, animated: true)
        }
    }
    
    func routeToLoginView(fromView view: SUEmailViewProtocol) {
        let loginController = LoginWireframe.configureLoginView()
        
        if let sourceView = view as? UIViewController {
            guard let controllersInStack = sourceView.navigationController?.childViewControllers.count else {
                return
            }
            
            if controllersInStack == 1 {
                sourceView.navigationController?.pushViewController(loginController, animated: true)
            } else if controllersInStack > 1 {
                sourceView.navigationController?.replaceViewControllers(last: controllersInStack - 1, to: [loginController])
            }
        }
    }
    
    func backToSplash(fromView view: SUEmailViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToMainTab(fromView view: SUEmailViewProtocol) {
        let tabBarController = TabBarWireframe.configureTabBar()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = tabBarController
        appDelegate?.window?.makeKeyAndVisible()

    }
}
