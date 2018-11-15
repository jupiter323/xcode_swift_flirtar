//
//  TabBarProtocols.swift
//  FlirtARViper
//
//  Created by  on 15.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit



protocol TabBarViewProtocol: class {
    var presenter: TabBarPresenterProtocol? {get set}
    
    func newMessageCome()
    
}

protocol TabBarWireframeProtocol {
    static func configureTabBar() -> UIViewController
    func dismissMe(fromView view: TabBarViewProtocol)
}

protocol TabBarPresenterProtocol {
    
    var view: TabBarViewProtocol? {get set}
    var interactor: TabBarInteractorInputProtocol? {get set}
    var wireframe: TabBarWireframeProtocol? {get set}
    
    func viewWillAppear()
    
    func registerDeviceForPushNotifications()
    
    func dismissMe()
    
}

protocol TabBarInteractorInputProtocol {
    
    var presenter: TabBarInteractorOutputProtocol? {get set}
    
    var remoteDatamanager: TabBarRemoteDatamanagerInputProtocol? {get set}
    func startRegisteringDeviceForPushNotifications()
    
    func startListenDialogs(withToken token: String)
    
}

protocol TabBarInteractorOutputProtocol: class {
    
    func newMessageCome()
    
}

protocol TabBarRemoteDatamanagerInputProtocol {
    func requestRegisterDeviceForPushNotifications(registerId: String,
                                                   type: String,
                                                   deviceId: String,
                                                   active: Bool)
}

