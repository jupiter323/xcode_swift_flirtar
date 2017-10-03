//
//  SUPinCodePresenter.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class SUPinCodePresenter: SUPinCodePresenterProcotol {
    
    
    var view: SUPinCodeViewProtocol?
    var wireframe: SUPinCodeWireframeProtocol?
    var interactor: SUPinCodeInteractorInputProtocol?
    
    func startPinCodeChecking(withPinCode pin: String) {
        view?.showActivityIndicator()
        interactor?.checkPinCode(withPinCode: pin)
    }
    
    func showPasswordView() {
        wireframe?.routeToPasswordView(fromView: view!)
    }
    func dismissMe() {
        wireframe?.backToSUEmail(fromView: view!)
    }
    
    
}

extension SUPinCodePresenter: SUPinCodeIntercatorOutputProtocol {
    
    func pinCodeIsCorrect() {
        view?.hideActivityIndicator()
        view?.showPinCodeIsCorrect()
    }
    
    func pinCodeIsNotCorrect(method: APIMethod, error: Error) {
        view?.hideActivityIndicator()
        
        
        var errorText = ""
        
        if (error as? PinCodeError) != nil {
            errorText = (error as! PinCodeError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.showPinCodeIsNotCorrect(method: method.rawValue, errorMessage: errorText)
    }
}
