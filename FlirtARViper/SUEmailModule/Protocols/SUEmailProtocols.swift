//
//  SUEmailProtocols.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


protocol SUEmailViewProtocol {
    
    var presenter: SUEmailPresenterProtocol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func showEmailIsAvailable()
    func showFBSuccessLogin()
    func showPinCodeSendSuccess()
    func showError(method: String, errorMessage: String)
}

protocol SUEmailWireframeProtocol {
    static func configureSUEmailView() -> UIViewController
    func routeToPinCodeView(fromView view: SUEmailViewProtocol)
    func routeToLoginView(fromView view: SUEmailViewProtocol)
    func backToSplash(fromView view: SUEmailViewProtocol)
    func routeToMainTab(fromView view: SUEmailViewProtocol)
}

protocol SUEmailPresenterProtocol {
    var view: SUEmailViewProtocol? {get set}
    var wireframe: SUEmailWireframeProtocol? {get set}
    var interactor: SUEmailInteractorInputProtocol? {get set}
    
    func startEmailAvailabilityChecking(withEmail email: String)
    func startSignUpWithFB()
    func startRequestPinCode()
    
    func showPinCodeView()
    func showLogin()
    func dismissMe()
    func showMainTab()

}

protocol SUEmailInteractorInputProtocol {
    var presenter: SUEmailIntercatorOutputProtocol? {get set}
    var remoteDatamanager: SUEmailRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: SUEmailLocalDatamanagerInputProtocol? {get set}
    func checkEmailAvailability(with email: String)
    func sendPinCode()
    
    func signUpWithFB()
}

protocol SUEmailIntercatorOutputProtocol {
    func emailIsAvailable()
    func signUpSuccess()
    func pinCodeSendSuccess()
    func requestError(method: APIMethod, error: Error)
}

protocol SUEmailRemoteDatamanagerOutputProtocol: class {
    func emailCheckSuccess()
    func pinCodeSendSuccess()
    func requestError(method: APIMethod, error: Error)
    func signedUp()
}


protocol SUEmailRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:SUEmailRemoteDatamanagerOutputProtocol? {get set}
    func requestEmailAvailability(withEmail email: String)
    func requestPinCode(forEmail email: String)
    func requestSignUpWithFB()
}

protocol SUEmailLocalDatamanagerInputProtocol: class {
    func saveUser(user: User, token: String, photos: [Photo]) throws
    func clearDB() throws
}












