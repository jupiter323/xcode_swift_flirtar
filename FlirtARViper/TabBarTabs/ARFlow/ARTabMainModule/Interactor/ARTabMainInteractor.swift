//
//  ARTabMainInteractor.swift
//  FlirtARViper
//
//  Created by   on 14.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation

class ARTabMainInteractor: ARTabMainInteractorInputProtocol {
    
    //MARK: - Init
    init() {
        queue.maxConcurrentOperationCount = maxQueueItems
    }
    
    //MARK: - Variables
    fileprivate var updateTimer = Timer()
    fileprivate var distance = 0.0
    fileprivate var queue = OperationQueue()
    fileprivate var maxQueueItems = 10
    
    
    //MARK: - ARTabMainInteractorInputProtocol
    weak var presenter: ARTabMainInteractorOutputProtocol?
    var remoteDatamanager: ARTabMainRemoteDatamanagerInputProtocol?
    
    func startGettingPeoplesForAR(byDistance distance: Double) {
        self.distance = distance
        updateTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(requestARPeoples), userInfo: nil, repeats: true)
    }
    
    @objc func requestARPeoples() {
        print("================Request sended")
        print("================Request distance: \(self.distance)")
        
        let operation = BlockOperation {
            self.remoteDatamanager?.requestPeoplesNear(byDistance: self.distance)
        }
        
        
        let lastOperation = self.queue.operations.last
        if lastOperation != nil {
            operation.addDependency(lastOperation!)
        }
        
        
        if queue.operationCount > maxQueueItems {
            queue.cancelAllOperations()
        }
        queue.addOperation(operation)
        
        
    }
    
    func stopGettingPeoplesForAR() {
        updateTimer.invalidate()
        queue.cancelAllOperations()
    }
}

//MARK: - ARTabMainRemoteDatamanagerOutputProtocol
extension ARTabMainInteractor: ARTabMainRemoteDatamanagerOutputProtocol {
    func recievedPeoples(peoples: [Marker]) {

        var annotations = [ARMarkerAnnotation]()
        
        //dictionary like [locationId: [markersWithSameLocation]]
        var dict = [Double:[Marker]]()


        //for each user check his locationValue
        for eachUser in peoples {
            //if it's not contain - create
            if dict[eachUser.locationValue] == nil {
                dict[eachUser.locationValue] = [eachUser]
            } else {
                //else add new marker to existing location
                dict[eachUser.locationValue]?.append(eachUser)
            }
            
        }
        
        //get array
        let markersArray = dict.values
        
        //create annotations
        for eachMarker in markersArray {
            let annotation = ARMarkerAnnotation(withMarker: eachMarker)
            if annotation != nil {
                annotations.append(annotation!)
            }
        }
        
        presenter?.didRecievePeoples(markerAnnotations: annotations)
        
        
    }
    
}
