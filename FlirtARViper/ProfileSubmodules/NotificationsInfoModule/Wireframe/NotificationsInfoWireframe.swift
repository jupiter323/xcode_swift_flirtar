//
//  NotificationsInfo.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class NotificationsInfoWireframe: NotificationsInfoWireframeProtocol {
    static func configureNotificationsInfoView() -> UIViewController {
        
        let notificationsController = UIStoryboard(name: "NotificationsInfo", bundle: nil).instantiateViewController(withIdentifier: "NotificationsInfoViewController")
        
        if let view = notificationsController as? NotificationsInfoViewController {
            
            let presenter = NotificationsInfoPresenter()
            let interactor = NotificationsInfoInteractor()
            let wireframe = NotificationsInfoWireframe()
            let remoteDatamanager = NotificationsInfoRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            
            return notificationsController
            
        }
        return UIViewController()
    }
}
