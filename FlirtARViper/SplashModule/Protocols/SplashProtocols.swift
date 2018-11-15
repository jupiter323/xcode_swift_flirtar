//
//  SplashProtocols.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol SplashViewProtocol: class {
    var presenter: SplashPresenterProtocol? {get set}
    func showActivityIndicator()
    func hideActivityIndicator()
    func showLoginError(method: String, errorMessage: String)
    func showSuccessLogin()
}

protocol SplashWireframeProtocol {
    static func configureSplashModule() -> UIViewController
    
    func routeToMainTab(fromView view: SplashViewProtocol)
    func routeToChoosePhotos(fromView view: SplashViewProtocol)
}

protocol SplashPresenterProtocol {
    var view: SplashViewProtocol? {get set}
    var wireframe: SplashWireframeProtocol? {get set}
    var interactor: SplashInteractorInputProtocol? {get set}
    
    func loginWithFB()
    
    func showNextScreen()
    
}


protocol SplashInteractorInputProtocol {
    var presenter: SplashIntercatorOutputProtocol? {get set}
    var remoteDatamanager: SplashRemoteDatamanagerInputProtocol? {get set}
    var localDatamanager: SplashLocalDatamanagerInputProtocol? {get set}
    
    func startLoginWithFB()
}

protocol SplashIntercatorOutputProtocol: class {
    func loggedInSuccess()
    func fbAuthFinished()
    func errorWhileLogIn(method: APIMethod, error: Error)
}

protocol SplashRemoteDatamanagerOutputProtocol: class {
    func loggedIn()
    func fbAuthFinished()
    func loginError(method: APIMethod, error: Error)
}


protocol SplashRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:SplashRemoteDatamanagerOutputProtocol? {get set}
    
    func requestLoginWithFB()
}


protocol SplashLocalDatamanagerInputProtocol: class {
    func saveUser(user: User, token: String, photos: [Photo]) throws
    func clearDB() throws
}



