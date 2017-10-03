//
//  TabBarWireframe.swift
//  FlirtARViper
//
//  Created by  on 04.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RAMAnimatedTabBarController

class TabBarWireframe: TabBarWireframeProtocol {
    
    
    static func configureTabBar() -> UIViewController {

        let tabController = TabBarViewController()
        
        
        let presenter = TabBarPresenter()
        let interactor = TabBarInteractor()
        let wireframe = TabBarWireframe()
        let remoteDatamanager = TabBarRemoteDatamanager()
        
        tabController.presenter = presenter
        presenter.view = tabController
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter
        interactor.remoteDatamanager = remoteDatamanager
        
        return tabController

    }
    
    func dismissMe(fromView view: TabBarViewProtocol) {
        var viewForClear = view
        viewForClear.presenter?.interactor?.remoteDatamanager = nil
        viewForClear.presenter?.interactor?.presenter = nil
        viewForClear.presenter?.interactor = nil
        viewForClear.presenter?.view = nil
        viewForClear.presenter?.wireframe = nil
        viewForClear.presenter = nil
    }
    
}
