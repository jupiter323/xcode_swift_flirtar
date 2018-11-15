//
//  SwitchView.swift
//  FlirtARViper
//
//  Created by  on 04.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol SwitchViewDelegate: class {
    func valueChanged(switchView: SwitchView)
}

class SwitchView: ViewFromXIB {

    //MARK: - Outlets
    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var delegate: SwitchViewDelegate?
    
    //MARK: - Configuration
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var isOn: Bool {
        set {
            switcher.isOn = newValue
        }
        get { return switcher.isOn }
    }
    
    @IBInspectable var activeColor: UIColor = UIColor(red: 235/255, green: 65/255, blue: 91/255, alpha: 1.0) {
        didSet {
            switcher.onTintColor = activeColor
        }
    }
    
    @IBInspectable var titleColor: UIColor = UIColor(red: 62/255, green: 67/255, blue: 79/255, alpha: 1.0) {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var setFromCode = false
    
    @IBAction func switchValueChanged(_ sender: Any) {
        print("_____ SWITCH DELEGATE: \(((sender as? UISwitch)?.isOn)!)")
        if setFromCode == false {
            delegate?.valueChanged(switchView: self)
        } else {
            setFromCode = false
        }
    }
    

}
