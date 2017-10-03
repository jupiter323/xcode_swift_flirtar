//
//  NotificationsTabInteractor.swift
//  FlirtARViper
//
//  Created by  on 11.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation


class NotificationsInfoInteractor: NotificationsInfoInteractorInputProtocol {
    weak var presenter: NotificationsInfoInteractorOutputProtocol?
    var remoteDatamanager: NotificationsInfoRemoteDatamanagerInputProtocol?
    
    fileprivate var cellType: CellConfiguration?
    
    func saveNotificationStatus(status: Bool, type: CellConfiguration) {
        cellType = type
        
        //check type here
        var requestType: CellConfiguration.NotificationType?
        switch type {
        case .Nofitication(.like):
            requestType = .like
        case .Nofitication(.message):
            requestType = .message
        case .Nofitication(.newUserInArea):
            requestType = .newUserInArea
        default:
            break
        }
        
        if requestType != nil {
            remoteDatamanager?.requestChangeNotification(withStatus: status, andType: requestType!)
        } else {
            if cellType != nil {
                presenter?.notificationsError(method: APIMethod.updateNotification, error: NotificationError.notificationTypeInvalid, type: cellType!)
            }
        }
    }
    
    func startGettingStatuses() {
        remoteDatamanager?.requestNotifications()
    }
}

extension NotificationsInfoInteractor: NotificationsInfoRemoteDatamanagerOutputProtocol {
    func notificationsChanged() {
        presenter?.notificationsSuccess()
    }
    func notificationChangeError(method: APIMethod, error: Error) {
        if cellType != nil {
            presenter?.notificationsError(method: method, error: error, type: cellType!)
        }
    }
    
    
    
    func notificationsRecieved(notifications: [NotificationTuple]) {
        presenter?.didReciveNotifications(notifications: notifications)
    }
    
    func errorWhileRecivingNotifications() {
        presenter?.recieveNotificationsFail()
    }
    
}
