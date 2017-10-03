//
//  UITabBarController+Extensions.swift
//  FlirtARViper
//
//  Created by  on 25.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class CustomTabBadgeLabel: UILabel { }

extension UITabBarController {
    func setBadges(badgeValues: [Int]) {
        
        for view in self.tabBar.subviews {
            if view is CustomTabBadgeLabel {
                view.removeFromSuperview()
            }
        }
        
        
        
        for index in 0...badgeValues.count-1 {
            if badgeValues[index] != 0 {
                addBadge(index: index,
                         value: badgeValues[index],
                         color: UIColor(red: 235/255, green: 65/255, blue: 91/255, alpha: 1.0),
                         font: UIFont(name: "Montserrat-Regular", size: 7)!)
            }
        }
    }
    
    func addBadge(index: Int, value: Int, color: UIColor, font: UIFont) {
        let badgeView = CustomTabBadgeLabel()
        
        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.font = font
        badgeView.text = String(value)
        badgeView.backgroundColor = color
        badgeView.tag = index
        tabBar.addSubview(badgeView)
        
        self.positionBadges()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.positionBadges()
    }
    
    // Positioning
    func positionBadges() {
        
        var tabbarButtons = self.tabBar.subviews.filter { (view: UIView) -> Bool in
            return view.isUserInteractionEnabled // only UITabBarButton are userInteractionEnabled
        }
        
        tabbarButtons = tabbarButtons.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })
        
        for view in self.tabBar.subviews {
            if view is CustomTabBadgeLabel {
                let badgeView = view as! CustomTabBadgeLabel
                self.positionBadge(badgeView: badgeView, items:tabbarButtons, index: badgeView.tag)
            }
        }
    }
    
    func positionBadge(badgeView: UIView, items: [UIView], index: Int) {
        
        let itemView = items[index]
        let center = itemView.center
        
        let xOffset: CGFloat = 14
        let yOffset: CGFloat = -14
        badgeView.frame.size = CGSize(width: 11, height: 11)
        badgeView.center = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        tabBar.bringSubview(toFront: badgeView)
    }
}
