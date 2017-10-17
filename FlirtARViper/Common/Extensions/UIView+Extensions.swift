//
//  UIView+Extensions.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

extension UIView {
    
    func setBorders(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func round(radius: CGFloat? = nil) {
        clipsToBounds = true
        let resultRadius = radius ?? frame.height / 2.0
        layer.cornerRadius = resultRadius
    }
    
    func setPassiveBorders() {
        let color = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        self.setBorders(width: 1.0, color: color)
    }
    
    func setActiveBorders() {
        let color = UIColor(red: 235/255, green: 65/255, blue: 91/255, alpha: 1.0)
        self.setBorders(width: 1.0, color: color)
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addCircle(centerPoint: CGPoint,
                   radius: CGFloat,
                   color: CGColor,
                   width: CGFloat = 6.0) {
        
        let radius = radius
        let circleAroundImage = UIBezierPath(arcCenter: centerPoint,
                                             radius: radius,
                                             startAngle: 0.0,
                                             endAngle: CGFloat(Double.pi * 2),
                                             clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circleAroundImage.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }
    
    func removeShapeLayers() {
        guard let sublayers = self.layer.sublayers else {return}
        for eachLayer in sublayers {
            if eachLayer is CAShapeLayer {
                eachLayer.removeFromSuperlayer()
            }
        }
    }
    
}
