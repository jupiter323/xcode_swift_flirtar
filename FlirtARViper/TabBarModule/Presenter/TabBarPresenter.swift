//
//  TabBarPresenter.swift
//  FlirtARViper
//
//  Created by  on 15.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


class TabBarPresenter: TabBarPresenterProtocol {
    
    
    weak var view: TabBarViewProtocol?
    var interactor: TabBarInteractorInputProtocol?
    var wireframe: TabBarWireframeProtocol?
    
    func registerDeviceForPushNotifications(){
        interactor?.startRegisteringDeviceForPushNotifications()
    }
    
    
    func viewWillAppear() {
        guard let token = ProfileService.token else {
            return
        }
        
        interactor?.startListenDialogs(withToken: token)
        
    }
    
    func dismissMe() {
        wireframe?.dismissMe(fromView: view!)
    }
    
}

extension TabBarPresenter: TabBarInteractorOutputProtocol {
    
    func newMessageCome() {
        view?.newMessageCome()
    }
}
