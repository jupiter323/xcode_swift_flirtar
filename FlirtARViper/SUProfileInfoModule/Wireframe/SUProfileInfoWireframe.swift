//
//  SUProfileInfoWireframe.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUProfileInfoWireframe: SUProfileInfoWireframeProtocol {
    
    static func configureSUProfileInfoView() -> UIViewController {
        let profileInfoController = UIStoryboard(name: "SUProfileInfo", bundle: nil).instantiateViewController(withIdentifier: "SUProfileInfoViewController")
        
        if let view = profileInfoController as? SUProfileInfoViewController {
            
            let presenter = SUProfileInfoPresenter()
            let interactor = SUProfileInfoInteractor()
            let wireframe = SUProfileInfoWireframe()
            let remoteDatamanager = SUProfileInfoRemoteDatamanager()
            let localDatamanager = SUProfileInfoLocalDatamanager()

            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return profileInfoController
            
        }
        return UIViewController()
    }

    func routeToTabBarView(fromView view: SUProfileInfoViewProtocol) {
        let tabBarController = TabBarWireframe.configureTabBar()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = tabBarController
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    
    func backToPhotosConfirm(fromView view: SUProfileInfoViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
}
