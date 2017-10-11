//
//  AccountInfoWireframe.swift
//  FlirtARViper
//
//  Created on 07.08.17.
//

import UIKit

class AccountInfoWireframe: AccountInfoWireframeProtocol {
    static func configureAccountInfoView() -> UIViewController {
        let accountInfoController = UIStoryboard(name: "AccountInfo", bundle: nil).instantiateViewController(withIdentifier: "AccountInfoViewController")
        
        if let view = accountInfoController as? AccountInfoViewController {
            
            
            let presenter = AccountInfoPresenter()
            let interactor = AccountInfoInteractor()
            let wireframe = AccountInfoWireframe()
            let remoteDatamanager = AccountInfoRemoteDatamanager()
            let localDatamanager = AccountInfoLocalDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            interactor.localDatamanager = localDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return accountInfoController
            
        }
        return UIViewController()
    }
    
    func routeToSplash(fromView view: AccountInfoViewProtocol) {
        let splashScreen = SplashWireframe.configureSplashModule()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = splashScreen
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    func routeToSelectLocation(fromView view: AccountInfoViewProtocol,
                               andPresenter presenter: AccountInfoPresenterProtocol) {
        let selectLocationController = UIStoryboard(name: "SelectLocation", bundle: nil).instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController
        guard let locationController = selectLocationController else {
            return
        }
        locationController.delegate = (presenter as! SelectLocationViewControllerDelegate)
        let mainTabController = (((view as? AccountInfoViewController)?.parent?.parent as? UINavigationController)?.parent as? TabBarViewController)!
        mainTabController.present(locationController, animated: true, completion: nil)
    }
    
    func routeToBlockedUsers(fromView view: AccountInfoViewProtocol) {
        let blockedUsers = BlockedUsersWireframe.configureBlockedUsersView()
        if let sourceView = view as? AccountInfoViewController {
            sourceView.present(blockedUsers, animated: true, completion: nil)
        }
    }
    
    func routeToInstagramAuth(fromView view: AccountInfoViewProtocol) {
        let instagramAuthController = UIStoryboard(name: "InstagramAuth", bundle: nil).instantiateViewController(withIdentifier: "InstagramAuthViewController")
        
        if let sourceView = view as? AccountInfoViewController {
            
            if instagramAuthController is InstagramAuthViewController {
                (instagramAuthController as! InstagramAuthViewController).delegate = sourceView
                sourceView.present(instagramAuthController, animated: true, completion: nil)
            }
            
            
            
        }
    }
    
}
