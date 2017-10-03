//
//  SUPinCodeWireframe.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUPinCodeWireframe: SUPinCodeWireframeProtocol {
    
    static func configureSUPinCodeView() -> UIViewController {
        
        let pinCodeController = UIStoryboard(name: "SUPinCode", bundle: nil).instantiateViewController(withIdentifier: "SUPinCodeViewController")
        
        if let view = pinCodeController as? SUPinCodeViewController {
            
            
            let presenter = SUPinCodePresenter()
            let interactor = SUPinCodeInteractor()
            let wireframe = SUPinCodeWireframe()
            let remoteDatamanager = SUPinCodeRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return pinCodeController
            
        }
        return UIViewController()
    }
    
    func routeToPasswordView(fromView view: SUPinCodeViewProtocol) {
        let passwordController = SUPasswordWireframe.configureSUPasswordView()
        if let sourceView = view as? UIViewController {
            sourceView.navigationController?.pushViewController(passwordController, animated: true)
        }

    }
    
    func backToSUEmail(fromView view: SUPinCodeViewProtocol) {
        if let sourceView = view as? UIViewController {
            let _ = sourceView.navigationController?.popViewController(animated: true)
        }
    }
}
