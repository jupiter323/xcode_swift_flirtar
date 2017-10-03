//
//  SeparatorView.swift
//  FlirtAR
//
//  Created by user on 7/5/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class SeparatorView: ViewFromXIB {

    //MARK: Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet var lineViews: [UIView]!
    
    
    //MARK: - Customization
    private var mainColor: UIColor = UIColor(red: 234/255, green: 236/255, blue: 241/255, alpha: 1.0)
    private var labelFont: UIFont = UIFont(name: "Montserrat-Regular", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
    
    
    override func draw(_ rect: CGRect) {
        lineViews.forEach {$0.backgroundColor = mainColor}
        label.font = labelFont
        label.textColor = mainColor
    }
    
    
}
