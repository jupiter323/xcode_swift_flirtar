//
//  MapTabRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import SwiftyJSON

class MapTabRemoteDatamanager: MapTabRemoteDatamanagerInputProtocol {
    

    weak var remoteRequestHandler: MapTabRemoteDatamanagerOutputProtocol?
    
    
    
    //need photo
    func requestPeoplesNear(byDistance distance: Double) {
        let request = APIRouter.getUsersLocations(byDistance: distance)
        
        NetworkManager
        .shared
        .sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.recievedPeoples(peoples: [Marker]())
            } else {
                guard let resultsJs = js!.array else {
                    self.remoteRequestHandler?.recievedPeoples(peoples: [Marker]())
                    return
                }
                
                let markers = APIParser().parseMarkers(js: resultsJs)
                self.remoteRequestHandler?.recievedPeoples(peoples: markers)
                
            }
        }
        
        
    }
    
    func requestUpdateUserLocation(withLongitude: Double, latitude: Double) {
        let request = APIRouter.updateUserLocation(longitude: withLongitude, latitude: latitude)
        
        NetworkManager
        .shared.sendAPIRequest(request: request) { (_, _) in
            
        }
        
    }
}
