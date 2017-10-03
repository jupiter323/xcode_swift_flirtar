//
//  ViewFromXIB.swift
//  FlirtAR
//
//  Created by user on 7/10/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ViewFromXIB: UIView {
    
    @IBOutlet var view: UIView!
    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let className = String(describing: type(of: self))
        
        _ = Bundle.main.loadNibNamed(className, owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let className = String(describing: type(of: self))
        
        _ = Bundle.main.loadNibNamed(className, owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
}
