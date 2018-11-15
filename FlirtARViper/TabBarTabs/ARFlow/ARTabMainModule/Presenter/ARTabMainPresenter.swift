//
//  ARTabMainPresenter.swift
//  FlirtARViper
//
//  Created by   on 14.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation


class ARTabMainPresenter: ARTabMainPresenterProtocol {
    weak var view: ARTabMainViewProtocol?
    var wireframe: ARTabMainWireframeProtocol?
    var interactor: ARTabMainInteractorInputProtocol?
    
    func viewWillAppear() {
        interactor?.startGettingPeoplesForAR(byDistance: 1.6) //1 mile request for 1.6km
    }
    
    func viewWillDissapear() {
        interactor?.stopGettingPeoplesForAR()
    }
    
    func openDetailProfile(forUser user: ShortUser) {
        wireframe?.routeToDetailProfile(fromView: view!,
                                        withUser: user)
    }
    
    func showShortProfile(markers: [Marker]) {
        wireframe?.presentShortProfile(fromView: view!,
                                       withMarkers: markers)
    }
    
    
}

extension ARTabMainPresenter: ARTabMainInteractorOutputProtocol {
    func didRecievePeoples(markerAnnotations: [ARMarkerAnnotation]) {
        view?.updateAnnotations(annotations: markerAnnotations)
    }

}
