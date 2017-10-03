//
//  TabBarRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 15.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TabBarRemoteDatamanager: TabBarRemoteDatamanagerInputProtocol {
    
    func requestRegisterDeviceForPushNotifications(registerId: String,
                                                   type: String,
                                                   deviceId: String,
                                                   active: Bool) {
        let request = APIRouter.registerDeviceForNotifications(registrationId: registerId,
                                                              type: type,
                                                              deviceId: deviceId,
                                                              status: active)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (_, _) in
                
        }
        
    }
}
