//
//  InputTextField.swift
//  FlirtAR
//
//  Created by user on 7/4/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class InputTextField: UITextField {

    @IBInspectable var margin: CGFloat = 16.0
    
    //MARK: - 
    
    override func draw(_ rect: CGRect) {
        //Initial configure
        round()
        setPassiveBorders()
        font = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        textColor = UIColor.darkGray
        
    }
    
    //set placeholder color
    override var attributedPlaceholder: NSAttributedString? {
        get {
            return self.attributedPlaceholder
        }
        
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName: UIColor(red: 122/255, green: 128/255, blue: 142/255, alpha: 1.0)])
        }
    }
    
    //MARK: Change states
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
       
        if result {
            setActiveBorders()
        }
        
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        
        if result {
            setPassiveBorders()
        }
        return result
    }
    
    //MARK: Margins
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(x: bounds.origin.x + margin,
                          y: 0,
                          width: bounds.size.width - margin * 2.0,
                          height: bounds.size.height)
        
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds:bounds)
    }

}
