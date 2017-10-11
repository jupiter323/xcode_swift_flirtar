//
//  KolodaOverlayView.swift
//  FlirtARViper
//
//  Created by on 25.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class KolodaOverlayView: OverlayView {
    
    @IBOutlet weak var yesImageView: UIImageView!
    @IBOutlet weak var noImageView: UIImageView!
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left?:
                yesImageView.isHidden = true
                noImageView.isHidden = false
            case .right?:
                yesImageView.isHidden = false
                noImageView.isHidden = true
            default:
                yesImageView.isHidden = true
                noImageView.isHidden = true
            }
            
        }
    }
    
}
