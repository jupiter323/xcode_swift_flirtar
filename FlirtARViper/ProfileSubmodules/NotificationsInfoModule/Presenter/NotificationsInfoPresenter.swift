//
//  NotificationsTabPresenter.swift
//  FlirtARViper
//
//  Created by  on 11.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation


class NotificationsInfoPresenter: NotificationsInfoPresenterProtocol {
    weak var view: NotificationsInfoViewProtocol?
    var wireframe: NotificationsInfoWireframeProtocol?
    var interactor: NotificationsInfoInteractorInputProtocol?
    
    func viewWillAppear() {
        view?.showActivityIndicator()
        interactor?.startGettingStatuses()
    }
    
    func saveNotification(isEnabled status: Bool, type: CellConfiguration) {
        view?.showActivityIndicator()
        interactor?.saveNotificationStatus(status: status, type: type)
    }
}

extension NotificationsInfoPresenter: NotificationsInfoInteractorOutputProtocol {
    func notificationsSuccess() {
        view?.hideActivityIndicator()
        view?.notificationChanged()
    }
    func notificationsError(method: APIMethod, error: Error, type: CellConfiguration) {
        view?.hideActivityIndicator()
        
        var errorText = ""
        if (error as? NotificationError) != nil  {
            errorText = (error as! NotificationError).localizedDescription
        } else {
            errorText = error.localizedDescription
        }
        
        view?.notificationChangeError(method: method.rawValue, errorMessage: errorText, type: type)
    }
    
    func didReciveNotifications(notifications: [NotificationTuple]) {
        view?.hideActivityIndicator()
        view?.showNotifications(notifications: notifications)
    }
    
    func recieveNotificationsFail() {
        view?.hideActivityIndicator()
        view?.showNotifications(notifications: [NotificationTuple]())
    }
}
