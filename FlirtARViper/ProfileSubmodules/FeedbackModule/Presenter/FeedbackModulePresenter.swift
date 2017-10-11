//
//  FeedbackModulePresenter.swift
//  FlirtARViper
//
//  Created by on 08.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

class FeedbackModulePresenter: FeedbackModulePresenterProtocol {
    weak var view: FeedbackModuleViewProtocol?
    var wireframe: FeedbackModuleWireframeProtocol?
    
    func openAppStoreRate() {
        wireframe?.routeToAppStore()
    }
    
    func openCustomRate() {
        wireframe?.routeToCustomFeedback(fromView: view!)
    }
}
