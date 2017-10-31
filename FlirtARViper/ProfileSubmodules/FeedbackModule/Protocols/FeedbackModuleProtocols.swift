//
//  FeedbackModuleProtocols.swift
//  FlirtARViper
//
//  Created by on 08.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

protocol FeedbackModuleViewProtocol: class {
    var presenter: FeedbackModulePresenterProtocol? {get set}
}

protocol FeedbackModuleWireframeProtocol {
    static func configureFeedbackModuleView() -> UIViewController
    
    func routeToAppStore()
    func routeToCustomFeedback(fromView view: FeedbackModuleViewProtocol)
    
}

protocol FeedbackModulePresenterProtocol {
    var view: FeedbackModuleViewProtocol? {get set}
    var wireframe: FeedbackModuleWireframeProtocol? {get set}
    
    func openAppStoreRate()
    func openCustomRate()
    
}


