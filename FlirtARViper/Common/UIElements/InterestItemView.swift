//
//  InterestItemView.swift
//  FlirtARViper
//
//  Created by   on 18.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit


class InterestItemView: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet var itemDotView: UIView!
    @IBOutlet weak var itemTitle: UILabel!
    
    //MARK: - Configuration
    @IBInspectable var title: String = " " {
        didSet {
            itemTitle.text = title
        }
    }
    
    @IBInspectable var dotColor: UIColor = UIColor(red: 235/255,
                                                  green: 65/255,
                                                  blue: 91/255,
                                                  alpha: 1.0) {
        didSet {
            itemDotView.backgroundColor = dotColor
        }
    }
    
    @IBInspectable var itemTextColor: UIColor = UIColor.white {
        didSet {
            itemTitle.textColor = itemTextColor
        }
    }
    
    @IBInspectable var itemTextFont: UIFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            itemTitle.font = itemTextFont
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        itemDotView.round()
        
        self.view!.superview?.backgroundColor = UIColor.clear
    }
    
    
    
    
}
