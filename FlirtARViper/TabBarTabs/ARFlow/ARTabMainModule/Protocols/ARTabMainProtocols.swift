//
//  ARTabMainProtocols.swift
//  FlirtARViper
//
//  Created by   on 05.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

protocol ARTabMainViewProtocol: class {
    
    var viperPresenter: ARTabMainPresenterProtocol? {get set}
    
    func updateAnnotations(annotations: [ARMarkerAnnotation])
    
}

protocol ARTabMainWireframeProtocol {
    static func configureARTabView() -> UIViewController
    func routeToDetailProfile(fromView view: ARTabMainViewProtocol,
                              withUser user: ShortUser)
    
    func presentShortProfile(fromView view: ARTabMainViewProtocol,
                             withMarkers markers: [Marker])
    
}

protocol ARTabMainPresenterProtocol {
    var view: ARTabMainViewProtocol? {get set}
    var wireframe: ARTabMainWireframeProtocol? {get set}
    var interactor: ARTabMainInteractorInputProtocol? {get set}
    
    func viewWillAppear()
    func viewWillDissapear()
    
    func openDetailProfile(forUser user: ShortUser)
    
    func showShortProfile(markers: [Marker])
    
    
}

protocol ARTabMainInteractorInputProtocol {
    
    var presenter: ARTabMainInteractorOutputProtocol? {get set}
    var remoteDatamanager: ARTabMainRemoteDatamanagerInputProtocol? {get set}
    
    func startGettingPeoplesForAR(byDistance distance: Double)
    func stopGettingPeoplesForAR()
    
}

protocol ARTabMainInteractorOutputProtocol: class {
    func didRecievePeoples(markerAnnotations: [ARMarkerAnnotation])
}


protocol ARTabMainRemoteDatamanagerOutputProtocol: class {
    func recievedPeoples(peoples: [Marker])
}



protocol ARTabMainRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:ARTabMainRemoteDatamanagerOutputProtocol? {get set}
    
    func requestPeoplesNear(byDistance distance: Double)
}










