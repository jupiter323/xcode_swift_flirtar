//
//  SUPasswordPresenter.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation

class SUPasswordPresenter: SUPasswordPresenterProcotol {
    var view: SUPasswordViewProtocol?
    var wireframe: SUPasswordWireframeProtocol?
    var interactor: SUPasswordInteractorInputProtocol?
    
    func showPhotosInfoView() {
        wireframe?.routeToPhotosInfoView(fromView: view!)
    }
    
    func dismissMe() {
        wireframe?.backToSUPinCode(fromView: view!)
    }
    
    func savePassword(password: String?) {
        interactor?.savePassword(password: password)
    }
}
