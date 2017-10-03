//
//  MapTabWireframe.swift
//  FlirtARViper
//
//  Created by  on 04.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class MapTabWireframe: MapTabWireframeProtocol  {
    
    static func configureMapTabView() -> UIViewController {
        
        let mapController = UIStoryboard(name: "MapTab", bundle: nil).instantiateViewController(withIdentifier: "MapTabViewController")
        
        if let view = mapController as? MapTabViewController {
            
            let presenter = MapTabPresenter()
            let interactor = MapTabInteractor()
            let wireframe = MapTabWireframe()
            let remoteDatamanager = MapTabRemoteDatamanager()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            presenter.interactor = interactor
            interactor.presenter = presenter
            interactor.remoteDatamanager = remoteDatamanager
            remoteDatamanager.remoteRequestHandler = interactor
            
            return mapController
            
        }
        return UIViewController()
    }
    
    func routeToProfileSettings(fromView view: MapTabViewProtocol) {
        if let parentView = view as? MapTabViewController {
            let tabBar = parentView.parent as? TabBarViewController
            let index = Tabs.tabsInOrder.index(of: .profile)
            let currentIndex = Tabs.tabsInOrder.index(of: .map)
            if index != nil, currentIndex != nil {
                tabBar?.setSelectIndex(from: currentIndex!, to: index!)
            }
            
        }
    }
}
