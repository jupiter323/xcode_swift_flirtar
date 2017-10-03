//
//  SUChoosePhotoWireframe.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUChoosePhotoWireframe: SUChoosePhotoWireframeProtocol {
    static func configureSUChoosePhotoView() -> UIViewController {
        let choosePhotoController = UIStoryboard(name: "SUChoosePhoto", bundle: nil).instantiateViewController(withIdentifier: "SUChoosePhotoViewController")
        
        if let view = choosePhotoController as? SUChoosePhotoViewController {
            
            
            let presenter = SUChoosePhotoPresenter()
            let wireframe = SUChoosePhotoWireframe()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            
            return choosePhotoController
            
        }
        return UIViewController()
    }
    
    func backToPassword(fromView view: SUChoosePhotoViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
    
    func routeToPhotosConfirm(fromView view: SUChoosePhotoViewProtocol,
                              sourceType type: PhotosProvider) {
        let confirmPhotoController = SUConfirmPhotoWireframe.configureSUConfirmPhotoView(withSourceType: type)
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(confirmPhotoController, animated: true)
        }
    }
}
