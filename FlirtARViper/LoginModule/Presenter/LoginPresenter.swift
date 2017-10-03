//
//  LoginPresenter.swift
//  FlirtARViper
//
//  Created by   on 01.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class LoginPresenter: LoginPresenterProtocol {
    var view: LoginViewProtocol?
    var wireframe: LoginWireframeProtocol?
    var interactor: LoginInteractorInputProtocol?
    
    
    func showPasswordRecover() {
        wireframe?.routeToPasswordRecover(fromView: view!)
    }
    
    func startLogin(with email: String, password: String) {
        view?.showActivityIndicator()
        interactor?.login(with: email, password: password)
    }
    
    func startLoginWithFB() {
        view?.showActivityIndicator()
        interactor?.loginWithFB()
    }
    
    func dismissMe() {
        wireframe?.backToSplash(fromView: view!)
    }
    
    func showSignup() {
        wireframe?.routeToSignUp(fromView: view!)
    }
    
    func showMainTab() {
        wireframe?.routeToMainTab(fromView: view!)
    }
}

extension LoginPresenter: LoginIntercatorOutputProtocol {
    func loggedInSuccess() {
        view?.hideActivityIndicator()
        view?.showSuccessLogin()
        //route to main screen
    }
    
    func errorWhileLogIn(method: APIMethod, error: Error) {
        
        var errorText = ""
        if (error as? LoginError) != nil  {
            errorText = (error as! LoginError).localizedDescription
        } else if (error as? FBAuthError) != nil {
            errorText = (error as! FBAuthError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.hideActivityIndicator()
        view?.showLoginError(method: method.rawValue, errorMessage: errorText)
    }
}
