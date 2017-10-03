//
//  LikesAnimationView.swift
//  FlirtARViper
//
//  Created by   on 17.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class LikesAnimationView: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet weak var bigLike: UIImageView!
    @IBOutlet weak var mediumLike: UIImageView!
    @IBOutlet weak var smallLike: UIImageView!
    
    func configureAnimation() {
        superview?.backgroundColor = UIColor.clear
        
        
        let moveVal: CGFloat = 20.0
        let maxDuration: Double = 1.8
        
        let bigLikeMovement = CABasicAnimation(keyPath: "position.y")
        bigLikeMovement.fromValue = bigLike.frame.origin.y + 30.0
        bigLikeMovement.toValue = bigLike.frame.origin.y - moveVal
        bigLikeMovement.duration = maxDuration
        
        let transition = CABasicAnimation(keyPath: "opacity")
        transition.fromValue = 1.0
        transition.toValue = 0.0
        transition.duration = 0.6
        transition.beginTime = 1.2
        
        let transitionIn = CABasicAnimation(keyPath: "opacity")
        transitionIn.fromValue = 0.0
        transitionIn.toValue = 1.0
        transitionIn.duration = 0.3
        transitionIn.beginTime = 0.0
        
        let group = CAAnimationGroup()
        group.duration = maxDuration
        group.animations = [bigLikeMovement, transition, transitionIn]
        group.repeatCount = Float.infinity
        group.beginTime = 0.1
        
        let mediumLikeMovement = CABasicAnimation(keyPath: "position.y")
        mediumLikeMovement.fromValue = mediumLike.frame.origin.y + 20.0
        mediumLikeMovement.toValue = mediumLike.frame.origin.y - moveVal
        mediumLikeMovement.duration = maxDuration
        
        let transitionIn2 = CABasicAnimation(keyPath: "opacity")
        transitionIn2.fromValue = 0.0
        transitionIn2.toValue = 1.0
        transitionIn2.duration = 0.5
        transitionIn2.beginTime = 0.0
        
        let smallLikeMovement = CABasicAnimation(keyPath: "position.y")
        smallLikeMovement.fromValue = smallLike.frame.origin.y + 10.0
        smallLikeMovement.toValue = smallLike.frame.origin.y - moveVal
        smallLikeMovement.duration = maxDuration
        
        let transitionIn3 = CABasicAnimation(keyPath: "opacity")
        transitionIn3.fromValue = 0.0
        transitionIn3.toValue = 1.0
        transitionIn3.duration = 0.8
        transitionIn3.beginTime = 0.0
        
        let group2 = CAAnimationGroup()
        group2.duration = maxDuration
        group2.animations = [mediumLikeMovement, transition, transitionIn2]
        group2.repeatCount = Float.infinity
        group2.beginTime = 0.2
        
        let group3 = CAAnimationGroup()
        group3.duration = maxDuration
        group3.animations = [smallLikeMovement, transition, transitionIn3]
        group3.repeatCount = Float.infinity
        group3.beginTime = 0.3
        
        bigLike.layer.add(group, forKey: nil)
        mediumLike.layer.add(group2, forKey: nil)
        smallLike.layer.add(group3, forKey: nil)

        
        
        
    }
}
