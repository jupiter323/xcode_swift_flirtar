//
//  TitledLabelView.swift
//  FlirtARViper
//
//  Created by  on 15.10.2017.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class TitledLabelView: ViewFromXIB {

    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    //MARK: - Configuration
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var dataText: String? {
        didSet {
            dataLabel.text = dataText
        }
    }

}
