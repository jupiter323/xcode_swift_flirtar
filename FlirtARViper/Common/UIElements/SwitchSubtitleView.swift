//
//  SwitchSubtitleView.swift
//  FlirtARViper
//
//  Created on 04.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol SwitchSubtitleViewDelegate: class {
    func valueChanged(switchView: SwitchSubtitleView)
}

class SwitchSubtitleView: ViewFromXIB {

    
    //MARK: - Outlets
    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    weak var delegate: SwitchSubtitleViewDelegate?
    
    //MARK: - Configuration
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle
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
    
    @IBInspectable var subTitleColor: UIColor = UIColor(red: 213/255, green: 216/255, blue: 224/255, alpha: 1.0) {
        didSet {
            subTitleLabel.textColor = subTitleColor
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
