//
//  NotificationsTabProtocols.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol NotificationsInfoViewProtocol: class {
    
    var presenter: NotificationsInfoPresenterProtocol? {get set}
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func notificationChanged()
    func notificationChangeError(method: String, errorMessage: String, type: CellConfiguration)
    
    func showNotifications(notifications: [NotificationTuple])
    
}

protocol NotificationsInfoWireframeProtocol {
    static func configureNotificationsInfoView() -> UIViewController
}

protocol NotificationsInfoPresenterProtocol {
    
    var view: NotificationsInfoViewProtocol? {get set}
    var wireframe: NotificationsInfoWireframeProtocol? {get set}
    var interactor: NotificationsInfoInteractorInputProtocol? {get set}
    
    func viewWillAppear()
    func saveNotification(isEnabled status: Bool, type: CellConfiguration)
    
}

protocol NotificationsInfoInteractorInputProtocol {
    var presenter: NotificationsInfoInteractorOutputProtocol? {get set}
    var remoteDatamanager: NotificationsInfoRemoteDatamanagerInputProtocol? {get set}
    
    func startGettingStatuses()
    func saveNotificationStatus(status: Bool, type: CellConfiguration)
    
}

protocol NotificationsInfoInteractorOutputProtocol: class {
    func notificationsSuccess()
    func notificationsError(method: APIMethod, error: Error, type: CellConfiguration)
    
    func didReciveNotifications(notifications: [NotificationTuple])
    func recieveNotificationsFail()
}



protocol NotificationsInfoRemoteDatamanagerOutputProtocol: class {
    func notificationsRecieved(notifications: [NotificationTuple])
    func errorWhileRecivingNotifications()
    
    func notificationsChanged()
    func notificationChangeError(method: APIMethod, error: Error)
}

protocol NotificationsInfoRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:NotificationsInfoRemoteDatamanagerOutputProtocol? {get set}
    func requestNotifications()
    func requestChangeNotification(withStatus status: Bool, andType type: CellConfiguration.NotificationType)
}




