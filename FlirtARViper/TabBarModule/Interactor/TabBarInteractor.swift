//
//  TabBarInteractor.swift
//  FlirtARViper
//
//  Created by  on 15.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import SwiftWebSocket
import SwiftyJSON

enum MessageNotificationName: String {
    case postNewDialog = "postNewDialogNotification"
}


class TabBarInteractor: TabBarInteractorInputProtocol {
    
    //MARK: - Variables
    fileprivate var socket: WebSocket?
    
    //MARK: - Helpers
    func initSocket(withToken token: String) {
        if socket == nil {
            socket = WebSocket("ws://52.204.177.82:8888/stream/\(token)/")
        }
        
        //MARK: - Socket implementation
        socket?.event.open = {
            print("opened")
        }
        
        socket?.event.error = { error in
            print("error \(error)")        }
        
        socket?.event.close = { code, reason, clean in
            print("close")
            self.socket?.open()
        }
        
        socket?.event.message = { message in
            print(message)
            
            
            
            guard let messageString = message as? String else {
                return
            }
            
            let js = JSON(parseJSON: messageString)
            
            let senderId = js["payload"]["data"]["sender"].intValue
            
            
            //if income message -> send notification and change badge
            if senderId != ProfileService.currentUser?.userID {
                
                let dataDictionary = ["data":messageString]
                
                NotificationCenter.default
                    .post(name: NSNotification.Name(MessageNotificationName.postNewDialog.rawValue),
                          object: nil,
                          userInfo: dataDictionary)
                
                self.presenter?.newMessageCome()
                
            }
            
            
        }
        
    }
    
    
    //MARK: - TabBarInteractorInputProtocol
    weak var presenter: TabBarInteractorOutputProtocol?
    var remoteDatamanager: TabBarRemoteDatamanagerInputProtocol?
    func startRegisteringDeviceForPushNotifications() {
        guard let deviceToken = ProfileService.fcmToken else { return }
        let deviceId = String(ProfileService.currentUser?.userID ?? 0)
        remoteDatamanager?
            .requestRegisterDeviceForPushNotifications(registerId: deviceToken,
                                                  type: "ios",
                                                  deviceId: deviceId,
                                                  active: true)
    }
    
    
    
    func startListenDialogs(withToken token: String) {
        initSocket(withToken: token)
        
    }
}
