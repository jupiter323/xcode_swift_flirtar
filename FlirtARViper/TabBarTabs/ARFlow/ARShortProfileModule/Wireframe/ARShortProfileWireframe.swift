//
//  ARShortProfileWireframe.swift
//  FlirtARViper
//
//  Created by Daniel Harold on 16.08.17.
//  Copyright © 2017 Daniel Harold. All rights reserved.
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
        
        let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUser: user)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(arProfileDetailController, animated: true)
        }
        
    }
}
