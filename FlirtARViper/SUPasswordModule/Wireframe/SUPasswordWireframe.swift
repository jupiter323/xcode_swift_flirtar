//
//  SUPasswordWireframe.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUPasswordWireframe: SUPasswordWireframeProtocol {
    static func configureSUPasswordView() -> UIViewController {
        let passwordController = UIStoryboard(name: "SUPassword", bundle: nil).instantiateViewController(withIdentifier: "SUPasswordViewController")
        
        if let view = passwordController as? SUPasswordViewController {
            
            
            let presenter = SUPasswordPresenter()
            let wireframe = SUPasswordWireframe()
            let interactor = SUPasswordInteractor()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            return passwordController
            
        }
        return UIViewController()
    }
    
    func routeToPhotosInfoView(fromView view: SUPasswordViewProtocol) {
        let choosePhotosController = SUChoosePhotoWireframe.configureSUChoosePhotoView()
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(choosePhotosController, animated: true)
        }
    }
    
    func backToSUPinCode(fromView view: SUPasswordViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
}
