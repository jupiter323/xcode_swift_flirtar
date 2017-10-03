//
//  BorderedButton.swift
//  FlirtARViper
//
//  Created by   on 01.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

class BorderedButton: RoundedButton {

    @IBInspectable var borderColor: UIColor = UIColor.lightGray
    @IBInspectable var borderWidth: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setBorders(width: borderWidth, color: borderColor)
    }

}
