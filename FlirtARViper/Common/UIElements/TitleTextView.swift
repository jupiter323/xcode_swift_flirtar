//
//  TitleTextView.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class TitleTextView: ViewFromXIB {

    
    //MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    //MARK: - Configuration
    @IBInspectable var title: String = " " {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var subTitle: String = " " {
        didSet {
            subTitleLabel.text = subTitle
        }
    }

}
