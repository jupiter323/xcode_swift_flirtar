//
//  SUPinCodeProtocols.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


protocol SUPinCodeViewProtocol {
    
    var presenter: SUPinCodePresenterProcotol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func showPinCodeIsCorrect()
    func showPinCodeIsNotCorrect(method: String, errorMessage: String)
    
}

protocol SUPinCodeWireframeProtocol {
    static func configureSUPinCodeView() -> UIViewController
    func routeToPasswordView(fromView view: SUPinCodeViewProtocol)
    func backToSUEmail(fromView view: SUPinCodeViewProtocol)
    
}

protocol SUPinCodePresenterProcotol {
    
    var view: SUPinCodeViewProtocol? {get set}
    var wireframe: SUPinCodeWireframeProtocol? {get set}
    var interactor: SUPinCodeInteractorInputProtocol? {get set}
    
    func startPinCodeChecking(withPinCode pin: String)
    func showPasswordView()
    func dismissMe()
    
}

protocol SUPinCodeInteractorInputProtocol {
    var presenter: SUPinCodeIntercatorOutputProtocol? {get set}
    var remoteDatamanager: SUPinCodeRemoteDatamanagerInputProtocol? {get set}
    func checkPinCode(withPinCode pin: String)
}

protocol SUPinCodeIntercatorOutputProtocol {
    func pinCodeIsCorrect()
    func pinCodeIsNotCorrect(method: APIMethod, error: Error)
}

protocol SUPinCodeRemoteDatamanagerOutputProtocol: class {
    func pinCodeCheckSuccess()
    func pinCodeCheckUnsuccess(method: APIMethod, error: Error)
}


protocol SUPinCodeRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:SUPinCodeRemoteDatamanagerOutputProtocol? {get set}
    func requestPinCodeChecking(withPinCode pin: String, andEmail email: String)
}
