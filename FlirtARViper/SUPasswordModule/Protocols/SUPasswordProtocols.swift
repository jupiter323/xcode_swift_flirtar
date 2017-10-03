//
//  SUPasswordProtocols.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


protocol SUPasswordViewProtocol {
    var presenter: SUPasswordPresenterProcotol? {get set}
}

protocol SUPasswordWireframeProtocol {
    static func configureSUPasswordView() -> UIViewController
    func routeToPhotosInfoView(fromView view: SUPasswordViewProtocol)
    func backToSUPinCode(fromView view: SUPasswordViewProtocol)
    
}

protocol SUPasswordPresenterProcotol {
    
    var view: SUPasswordViewProtocol? {get set}
    var wireframe: SUPasswordWireframeProtocol? {get set}
    var interactor: SUPasswordInteractorInputProtocol? {get set}
    
    func savePassword(password: String?)
    
    func showPhotosInfoView()
    func dismissMe()
    
}

protocol SUPasswordInteractorInputProtocol {
    func savePassword(password: String?)
}
