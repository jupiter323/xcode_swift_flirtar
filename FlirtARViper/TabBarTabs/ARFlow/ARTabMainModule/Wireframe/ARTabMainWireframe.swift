//
//  ARTabMainWireframe.swift
//  FlirtARViper
//
//  Created by   on 05.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import CoreLocation

class ARTabMainWireframe: NSObject, ARTabMainWireframeProtocol {

    static func configureARTabView() -> UIViewController {
        
        let arNavigationController = UIStoryboard(name: "ARTabMain", bundle: nil).instantiateViewController(withIdentifier: "ARTabNavigation")
        
        if let view = arNavigationController.childViewControllers.first as? ARTabMainViewController {
            
            let presenter = ARTabMainPresenter()
            let interactor = ARTabMainInteractor()
            let wireframe = ARTabMainWireframe()
            let remoteDatamanager = ARTabMainRemoteDatamanager()
            
            view.viperPresenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return arNavigationController
        }
    
        return UIViewController()
        
    }
    
    func presentShortProfile(fromView view: ARTabMainViewProtocol,
                             withMarkers markers: [Marker]) {
        
        let shortProfile = ARShortProfileWireframe.configureARShortProfileView(withMarkers: markers)
        
        (shortProfile as? ARShortProfileViewController)?.delegate = view as? ARTabMainViewController
        
        if let sourceView = view as? UIViewController {
            sourceView.addChildViewController(shortProfile)
            sourceView.view.addSubview(shortProfile.view)
        }
        
    }
    
    
    
    func routeToDetailProfile(fromView view: ARTabMainViewProtocol,
                              withUser user: ShortUser) {
        let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUser: user)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(arProfileDetailController, animated: true)
        }
    }
    
    
    
    
}
