//
//  ARTabMainRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by   on 14.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ARTabMainRemoteDatamanager: ARTabMainRemoteDatamanagerInputProtocol {
    weak var remoteRequestHandler:ARTabMainRemoteDatamanagerOutputProtocol?
    
    func requestPeoplesNear(byDistance distance: Double) {
        let request = APIRouter.getUsersLocations(byDistance: distance)
        
        NetworkManager
            .shared
            .sendAPIRequest(request: request) { (js, _) in
                if js != nil {
                    if let resultsJs = js!.array {
                        let markers = APIParser().parseMarkers(js: resultsJs)
                        self.remoteRequestHandler?.recievedPeoples(peoples: markers)
                    } else {
                        self.remoteRequestHandler?.recievedPeoples(peoples: [Marker]())
                    }
                } else {
                    self.remoteRequestHandler?.recievedPeoples(peoples: [Marker]())
                }
        }
        
    }

}
