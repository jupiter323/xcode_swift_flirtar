//
//  ProfileMainTabWireframe.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class ProfileMainTabWireframe: ProfileMainTabWireframeProtocol {
    static func configureProfileMainTapView() -> UIViewController {
        let profileNavigationController = UIStoryboard(name: "ProfileMainTab", bundle: nil).instantiateViewController(withIdentifier: "ProfileMainTabNavigation")
        
        if let view = profileNavigationController.childViewControllers.first as? ProfileMainTabViewController {
            
            let presenter = ProfileMainTabPresenter()
            let interactor = ProfileMainTabInteractor()
            let wireframe = ProfileMainTabWireframe()
            let remoteDatamanager = ProfileMainTabRemoteDatamanager()
            let localDatamanager = ProfileMainTabLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            
            return profileNavigationController
        }
        
        return UIViewController()
    }
    
    func routeToProfileSettings(fromView view: ProfileMainTabViewProtocol?) {
        let profileSettingsController = ProfileSettingsWireframe.configureProfileSettingsView()
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(profileSettingsController, animated: true)
        }
    }
}
