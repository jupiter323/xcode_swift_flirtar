//
//  SULicenseWireframe.swift
//  FlirtARViper
//
//  Created by on 18.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class SULicenseWireframe: SULicenseWireframeProtocol {
    
    static func configureSULicenseView() -> UIViewController {
        let licenseController = UIStoryboard(name: "SULicense", bundle: nil).instantiateViewController(withIdentifier: "SULicenseViewController")
        
        if let view = licenseController as? SULicenseViewController {
            
            let presenter = SULicensePresenter()
            let interactor = SULicenseInteractor()
            let wireframe = SULicenseWireframe()
            let remoteDatamanager = SULicenseRemoteDatamanager()
            let localDatamanager = SULicenseLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return licenseController
            
        }
        return UIViewController()
    }
    
    func routeToTabBarView(fromView view: SULicenseViewProtocol) {
        let tabBarController = TabBarWireframe.configureTabBar()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = tabBarController
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    func backToProfileConfirm(fromView view: SULicenseViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
}
