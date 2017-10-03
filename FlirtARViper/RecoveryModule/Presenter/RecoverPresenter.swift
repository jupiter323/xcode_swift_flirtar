//
//  RecoverPresenter.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class RecoverPresenter: RecoveryPresenterProtocol {
    
    var view: RecoveryViewProtocol?
    var wireframe: RecoveryWireframeProtocol?
    var interactor: RecoveryInteractorInputProtocol?
    
    
    func startPasswordRecovering(with email: String) {
        view?.showActivityIndicator()
        interactor?.recoverPassword(with: email)
    }
    
    func dismissMe() {
        wireframe?.backToLogin(fromView: view!)
    }
    
    func showSignup() {
        wireframe?.routeToSignUp(fromView: view!)
    }
}

extension RecoverPresenter: RecoveryIntercatorOutputProtocol {
    func passwordRecoverSuccess() {
        view?.hideActivityIndicator()
        view?.showSuccessRecover()
    }
    
    func errorWhilePasswordRecovering(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? PasswordRecoverError) != nil  {
            errorText = (error as! PasswordRecoverError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showRecoverError(method: method.rawValue, errorMessage: errorText)
    }
}
