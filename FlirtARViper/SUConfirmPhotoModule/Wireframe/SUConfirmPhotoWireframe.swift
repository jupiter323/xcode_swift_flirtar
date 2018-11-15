//
//  SUConfirmPhotoWireframe.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUConfirmPhotoWireframe: SUConfirmPhotoWireframeProtocol {
    
    static func configureSUConfirmPhotoView(withSourceType type: PhotosProvider) -> UIViewController {
        let confirmPhotoController = UIStoryboard(name: "SUConfirmPhoto", bundle: nil).instantiateViewController(withIdentifier: "SUConfirmPhotoViewController")
        
        if let view = confirmPhotoController as? SUConfirmPhotoViewController {
            
            
            let presenter = SUConfirmPhotoPresenter(withType: type)
            let wireframe = SUConfirmPhotoWireframe()
            let interactor = SUConfirmPhotoInteractor()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            return confirmPhotoController
            
        }
        return UIViewController()
    }
    
    func backToPassword(fromView view: SUConfirmPhotoViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToProfileConfirm(fromView view: SUConfirmPhotoViewProtocol) {
        let profileConfirmController = SUProfileInfoWireframe.configureSUProfileInfoView()
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(profileConfirmController, animated: true)
        }
    }
}
