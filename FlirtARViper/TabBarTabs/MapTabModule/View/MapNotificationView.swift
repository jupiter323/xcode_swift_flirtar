//
//  MapNotificationView.swift
//  FlirtARViper
//
//  Created by   on 10.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

protocol MapNotificationViewDelegate: class {
    func openProfileSettings()
}

class MapNotificationView: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var messageView: UILabel!
    
    
    weak var delegate: MapNotificationViewDelegate?
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureView() {
        
        self.view!.superview?.backgroundColor = UIColor.clear
        
        roundedView.layoutIfNeeded()
        roundedView.layer.cornerRadius = 5.0
    }
    
    //MARK: - Action
    @IBAction func profileSettingsTap(_ sender: Any) {
        delegate?.openProfileSettings()
    }
}
