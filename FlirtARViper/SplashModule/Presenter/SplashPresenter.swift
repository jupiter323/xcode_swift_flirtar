//
//  SplashPresenter.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation

class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol?
    var wireframe: SplashWireframeProtocol?
    var interactor: SplashInteractorInputProtocol?
    
    func loginWithFB() {
        view?.showActivityIndicator()
        interactor?.startLoginWithFB()
    }
    
    func showNextScreen() {
        
        if ProfileService.recievedPhotos.count != 3 {
            wireframe?.routeToChoosePhotos(fromView: view!)
        } else {
            wireframe?.routeToMainTab(fromView: view!)
        }
    }
}

extension SplashPresenter: SplashIntercatorOutputProtocol {
    func loggedInSuccess() {
        view?.hideActivityIndicator()
        view?.showSuccessLogin()
    }
    
    func errorWhileLogIn(method: APIMethod, error: Error) {
        var errorText = ""
        if (error as? FBAuthError) != nil {
            errorText = (error as! FBAuthError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.hideActivityIndicator()
        view?.showLoginError(method: method.rawValue, errorMessage: errorText)
    }
}
