//
//  TitledInputView.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


class TitledInputView: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var inputField: InputTextField!
    
    
    
    
    //MARK: Configuration
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var subTitleString: String? = "" {
        didSet {
            subTitleLabel.text = subTitleString
        }
    }
    
    @IBInspectable var inputPlaceholder: String? = "" {
        didSet {
            inputField.placeholder = inputPlaceholder
        }
    }
    
    @IBInspectable var text: String? {
        set{
            inputField.text = newValue
        }
        get{
            return inputField.text
        }
    }
    
    @IBInspectable var isChangeable: Bool = true {
        didSet {
            if isChangeable == false {
                isUserInteractionEnabled = false
                inputField.backgroundColor = UIColor(red: 62/255,
                                                     green: 67/255,
                                                     blue: 79/255,
                                                     alpha: 0.05)
            }
        }
    }
    
    
    override func resignFirstResponder() -> Bool {
        return inputField.resignFirstResponder()
    }
}
