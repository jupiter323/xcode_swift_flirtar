//
//  LoginProtocols.swift
//  FlirtARViper
//
//  Created by   on 01.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

protocol LoginViewProtocol: class {
    var presenter: LoginPresenterProtocol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func showLoginError(method: String, errorMessage: String)
    func showSuccessLogin()
}

protocol LoginWireframeProtocol {
    static func configureLoginView() -> UIViewController
    func routeToPasswordRecover(fromView view: LoginViewProtocol)
    func backToSplash(fromView view: LoginViewProtocol)
    func routeToSignUp(fromView view: LoginViewProtocol)
    func routeToMainTab(fromView view: LoginViewProtocol)
}

protocol LoginPresenterProtocol {
    var view: LoginViewProtocol? {get set}
    var wireframe: LoginWireframeProtocol? {get set}
    var interactor: LoginInteractorInputProtocol? {get set}
    
    func showPasswordRecover()
    func showSignup()
    func startLogin(with email: String, password: String)
    func startLoginWithFB()
    func dismissMe()
    func showMainTab()
}


protocol LoginInteractorInputProtocol {
    var presenter: LoginIntercatorOutputProtocol? {get set}
    var remoteDatamanager: LoginRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: LoginLocalDatamanagerInputProtocol? {get set}
    func login(with email: String, password: String)
    func loginWithFB()
}

protocol LoginIntercatorOutputProtocol {
    func loggedInSuccess()
    func errorWhileLogIn(method: APIMethod, error: Error)
}

protocol LoginRemoteDatamanagerOutputProtocol: class {
    func loggedIn()
    func loginError(method: APIMethod, error: Error)
}


protocol LoginRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:LoginRemoteDatamanagerOutputProtocol? {get set}
    
    func requestLogin(with email: String, password: String)
    func requestLoginWithFB()
}


protocol LoginLocalDatamanagerInputProtocol: class {
    func saveUser(user: User, token: String, photos: [Photo]) throws
    func clearDB() throws
}





