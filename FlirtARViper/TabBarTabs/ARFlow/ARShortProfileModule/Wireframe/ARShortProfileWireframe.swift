//
//  ARShortProfileWireframe.swift
//  FlirtARViper
//
//  Created by on 16.08.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ARShortProfileWireframe: ARShortProfileWireframeProtocol {
    
    static func configureARShortProfileView(withMarkers: [Marker]) -> UIViewController {
        let arShortProfileController = UIStoryboard(name: "ARShortProfile", bundle: nil).instantiateViewController(withIdentifier: "ARShortProfileViewController")
        
        
        if let view = arShortProfileController as? ARShortProfileViewController {
            
            let presenter = ARShortProfilePresenter()
            let interactor = ARShortProfileInteractor()
            let wireframe = ARShortProfileWireframe()
            let remoteDatamanager = ARShortProfileRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.markers = withMarkers
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return arShortProfileController
        }
        
        return UIViewController()
    }
    
    
    func showFullInfo(fromView view: ARShortProfileViewProtocol,
                      withUser user: ShortUser) {
        
        let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUser: user) as? ARProfileViewController
        arProfileDetailController?.delegate = view as? ARShortProfileViewController
        if let sourceView = view as? UIViewController {
            if arProfileDetailController != nil {
                sourceView.present(arProfileDetailController!,
                                   animated: true, completion: nil)
            }
        }
        
    }
}
