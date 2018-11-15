//
//  UINavigationController+Extensions.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//


import UIKit

extension UINavigationController {
    
    func replaceViewControllers(last count: Int, to newControllers: [UIViewController]) {
        
        guard newControllers.count > 0 else {
            return
        }
        
        var existingControllers = viewControllers
        
        
        
        let start = existingControllers.count - count
        let end = existingControllers.count
        
        existingControllers.removeSubrange(start..<end)
        
        for eachController in newControllers {
            existingControllers.insert(eachController, at: existingControllers.endIndex)
        }
        
        self.setViewControllers(existingControllers, animated: true)
    }
    
}
