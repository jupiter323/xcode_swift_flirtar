//
//  TextNotificationView.swift
//  FlirtARViper
//
//  Created by on 06.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

enum TextNotificationViewTexts: String {
    case userBlocked = "User has been blocked. You can unblock user in your account settings"
    case userReported = "User has been reported. Thanks"
}


class TextNotificationView: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureView(withText text: String) {
        
        self.view!.superview?.backgroundColor = UIColor.clear
        
        roundedView.layoutIfNeeded()
        roundedView.layer.cornerRadius = 5.0
        
        textLabel.text = text
        
    }
    
    
}
