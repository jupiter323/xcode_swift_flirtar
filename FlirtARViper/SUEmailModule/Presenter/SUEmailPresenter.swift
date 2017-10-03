//
//  SUEmailPresenter.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUEmailPresenter: SUEmailPresenterProtocol {
    var view: SUEmailViewProtocol?
    var wireframe: SUEmailWireframeProtocol?
    var interactor: SUEmailInteractorInputProtocol?
    
    
    func startEmailAvailabilityChecking(withEmail email: String) {
        view?.showActivityIndicator()
        interactor?.checkEmailAvailability(with: email)
    }
    
    func startSignUpWithFB() {
        view?.showActivityIndicator()
        interactor?.signUpWithFB()
    }
    
    func startRequestPinCode() {
        view?.showActivityIndicator()
        interactor?.sendPinCode()
    }
    
    func showPinCodeView() {
        wireframe?.routeToPinCodeView(fromView: view!)
    }
    
    func showLogin() {
        wireframe?.routeToLoginView(fromView: view!)
    }
    
    func dismissMe() {
        wireframe?.backToSplash(fromView: view!)
    }
    
    func showMainTab() {
        wireframe?.routeToMainTab(fromView: view!)
    }
}


extension SUEmailPresenter: SUEmailIntercatorOutputProtocol {
    
    func emailIsAvailable() {
        view?.hideActivityIndicator()
        view?.showEmailIsAvailable()
    }
    
    func signUpSuccess() {
        view?.hideActivityIndicator()
        view?.showFBSuccessLogin()
    }
    
    func pinCodeSendSuccess() {
        view?.hideActivityIndicator()
        view?.showPinCodeSendSuccess()
    }
    
    func requestError(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? LoginError) != nil  {
            errorText = (error as! LoginError).localizedDescription
        } else if (error as? FBAuthError) != nil {
            errorText = (error as! FBAuthError).localizedDescription
        } else if (error as? EmailCheckError) != nil {
            errorText = (error as! EmailCheckError).localizedDescription
        } else if (error as? PinCodeError) != nil {
            errorText = (error as! PinCodeError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showError(method: method.rawValue, errorMessage: errorText)
    }
    
}
