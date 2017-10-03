//
//  NotificationsTabRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 11.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NotificationsInfoRemoteDatamanager: NotificationsInfoRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:NotificationsInfoRemoteDatamanagerOutputProtocol?
    func requestChangeNotification(withStatus status: Bool, andType type: CellConfiguration.NotificationType) {
        
        
        let request = APIRouter.updateNotificationSettings([(type, status)])
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.notificationChangeError(method: APIMethod.updateNotification, error: error!)
                } else {
                    if js! != JSON.null {
                        self.remoteRequestHandler?.notificationsChanged()
                    }
                }
        }
        
    }
    
    
    
    func requestNotifications() {
        let request = APIRouter.getNotifications()
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, error) in
                if error != nil {
                    self.remoteRequestHandler?.errorWhileRecivingNotifications()
                } else {
                    if js! != JSON.null {
                        let likeStatus = js![ServerNotificationsJSONKeys.like.rawValue].boolValue
                        let messageStatus = js![ServerNotificationsJSONKeys.message.rawValue].boolValue
                        let userStatus = js![ServerNotificationsJSONKeys.user.rawValue].boolValue
                        
                        
                        let like: NotificationTuple = (type: CellConfiguration.Nofitication(.like), status: likeStatus)
                        let message: NotificationTuple = (type: CellConfiguration.Nofitication(.message), status: messageStatus)
                        let user: NotificationTuple = (type: CellConfiguration.Nofitication(.newUserInArea), status: userStatus)
                        
                        
                        self.remoteRequestHandler?.notificationsRecieved(notifications: [like, message, user])
                    } else {
                        self.remoteRequestHandler?.errorWhileRecivingNotifications()
                    }
                }
        }
        
    }
    
    
}
