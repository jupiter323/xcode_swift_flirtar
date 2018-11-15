//
//  FeedbackModuleWireframe.swift
//  FlirtARViper
//
//  Created by on 08.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

class FeedbackModuleWireframe: FeedbackModuleWireframeProtocol {
    static func configureFeedbackModuleView() -> UIViewController {
        let feedbackModuleController = UIStoryboard(name: "FeedbackModule", bundle: nil).instantiateViewController(withIdentifier: "FeedbackModuleViewController")
        
        if let view = feedbackModuleController as? FeedbackModuleViewController {
            
            let presenter = FeedbackModulePresenter()
            let wireframe = FeedbackModuleWireframe()
            
            view.presenter = presenter
            presenter.view = view
            presenter.wireframe = wireframe
            
            return feedbackModuleController
            
        }
        return UIViewController()
    }
    
    func routeToAppStore() {
        if let url = URL(string: ExternalLinks.itunesLink.rawValue),
            UIApplication.shared.canOpenURL(url){
            if #available(iOS 10, *) {
                UIApplication.shared.open(url,
                                          options: [:],
                                          completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
    func routeToCustomFeedback(fromView view: FeedbackModuleViewProtocol) {
        let mainController = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        
        //if user logged in and using application -> show rateapp
        if mainController is TabBarViewController {
            let mainView = mainController?.view
            let rateApp = RateAppNotificationView(frame: UIScreen.main.bounds)
            rateApp.configureView(withTitle: "Do you like Flirtar?",
                                  subTitle: "Tap the number of stars you'd give us on a scale from 1-5",
                                  openAppStore: false)
            mainView?.addSubview(rateApp)
        }
    }
}
