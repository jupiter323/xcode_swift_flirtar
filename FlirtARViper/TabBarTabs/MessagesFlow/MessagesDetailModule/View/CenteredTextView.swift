//
//  CenteredTextView.swift
//  FlirtARViper
//
//  Created on 01.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class CenteredTextView: UITextView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        
        var viewBounds = bounds
        let newHeight = sizeThatFits(CGSize(
            width: bounds.size.width,
            height: CGFloat.greatestFiniteMagnitude)
            ).height
        viewBounds.size.height = newHeight
        bounds = viewBounds
    }
}
