//
//  SplashWireframe.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SplashWireframe: SplashWireframeProtocol {
    static func configureSplashModule() -> UIViewController {
        
        let navigationController = UIStoryboard(name: "Splash", bundle: nil).instantiateViewController(withIdentifier: "splashNaviagation")
        
        if let view = navigationController.childViewControllers.first as? SplashViewController {
            let interactor = SplashInteractor()
            let presenter = SplashPresenter()
            let wireframe = SplashWireframe()
            let remoteDatamanager = SplashRemoteDatamanager()
            let localDatamanager = SplashLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return navigationController
        }
        
        return UIViewController()
    }
    
    func routeToMainTab(fromView view: SplashViewProtocol) {
        let tabBarController = TabBarWireframe.configureTabBar()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = tabBarController
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    func routeToChoosePhotos(fromView view: SplashViewProtocol) {
        let choosePhotosController = SUChoosePhotoWireframe.configureSUChoosePhotoView()
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(choosePhotosController, animated: true)
        }
    }
}
