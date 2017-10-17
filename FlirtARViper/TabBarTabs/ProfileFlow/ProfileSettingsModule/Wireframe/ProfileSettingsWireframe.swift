//
//  ProfileSettingsWireframe.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class ProfileSettingsWireframe: ProfileSettingsWireframeProtocol {
    
    static func configureProfileSettingsView() -> UIViewController {
        let profileSettingsController = UIStoryboard(name: "ProfileSettings", bundle: nil).instantiateViewController(withIdentifier: "ProfileSettingsViewController")
        
        if let view = profileSettingsController as? ProfileSettingsViewController {
            
            let presenter = ProfileSettingsPresenter()
            let interactor = ProfileSettingsInteractor()
            let wireframe = ProfileSettingsWireframe()
            let remoteDatamanager = ProfileSettingsRemoteDatamanager()
            let localDatamanager = ProfileSettingsLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return profileSettingsController
            
        }
        return UIViewController()
    }
    
    func routeToSplash(fromView view: ProfileSettingsViewProtocol) {
        let splashScreen = SplashWireframe.configureSplashModule()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = splashScreen
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    func backToProfileMainTab(fromView view: ProfileSettingsViewProtocol){
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
}
