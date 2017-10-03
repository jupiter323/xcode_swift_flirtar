//
//  RecoveryProtocols.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol RecoveryViewProtocol: class {
    var presenter: RecoveryPresenterProtocol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func showRecoverError(method: String, errorMessage: String)
    func showSuccessRecover()
}

protocol RecoveryWireframeProtocol {
    static func configureRecoverView() -> UIViewController
    func backToLogin(fromView view: RecoveryViewProtocol)
    func routeToSignUp(fromView view: RecoveryViewProtocol)
}

protocol RecoveryPresenterProtocol {
    var view: RecoveryViewProtocol? {get set}
    var wireframe: RecoveryWireframeProtocol? {get set}
    var interactor: RecoveryInteractorInputProtocol? {get set}
    
    func startPasswordRecovering(with email: String)
    func showSignup()
    func dismissMe()
}


protocol RecoveryInteractorInputProtocol {
    var presenter: RecoveryIntercatorOutputProtocol? {get set}
    var remoteDatamanager: RecoveryRemoteDatamanagerInputProtocol? {get set}
    func recoverPassword(with email: String)
}

protocol RecoveryIntercatorOutputProtocol {
    func passwordRecoverSuccess()
    func errorWhilePasswordRecovering(method: APIMethod, error: Error)
}

protocol RecoveryRemoteDatamanagerOutputProtocol: class {
    func passwordRecovered()
    func passwordRecoverError(method: APIMethod, error: Error)
}


protocol RecoveryRemoteDatamanagerInputProtocol: class {
    var remoteRequestHandler:RecoveryRemoteDatamanagerOutputProtocol? {get set}
    func requestPasswordRecover(with email: String)
}
