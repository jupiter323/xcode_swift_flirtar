//
//  PinCodeInputView.swift
//  FlirtAR
//
//  Created by user on 7/13/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

protocol PinCodeInputViewDelegate: class {
    func pinCodeDidFill(withValue value: String)
}

class PinCodeInputView: ViewFromXIB {

    weak var delegate: PinCodeInputViewDelegate?
    
    var valueCount: Int {
        return valueLabels.count
    }
    
    //MARK: Public config
    
    @IBInspectable var placeholderSymbol: String = "x"
    @IBInspectable var underLinePassiveColor: UIColor = UIColor(red: 213/255, green: 216/255, blue: 224/255, alpha: 1.0)
    @IBInspectable var underLineActiveColor: UIColor? = UIColor(red: 235/255, green: 65/255, blue: 91/255, alpha: 1.0)
    @IBInspectable var textColor: UIColor = UIColor(red: 62/255, green: 67/255, blue: 79/255, alpha: 1.0)
    @IBInspectable var placeholderTextColor: UIColor = UIColor(red: 213/255, green: 216/255, blue: 224/255, alpha: 1.0)
    
    //MARK: Outlets
    
    @IBOutlet fileprivate var valueLabels: [UILabel]!
    @IBOutlet fileprivate var underLineViews: [UIView]!
    @IBOutlet weak var textField: UITextField!

    
    private var labelFont: UIFont = UIFont(name: "VarelaRound", size: 32.0) ?? UIFont.systemFont(ofSize: 32.0)
    
    override func draw(_ rect: CGRect) {
        textField.tintColor = UIColor.clear
        textField.textColor = UIColor.clear
        if textField.text?.isEmpty == true {
            valueLabels.forEach({$0.text = placeholderSymbol})
            valueLabels.forEach({$0.textColor = placeholderTextColor})
            valueLabels.forEach({$0.font = labelFont})
        }
    }
}

extension PinCodeInputView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        
        if let nsString = textField.text as NSString? {
            
            let resultText = nsString.replacingCharacters(in: range, with: string)
            
            if resultText.characters.count > valueLabels.count {
                result = false
            } else {
                let strings = resultText.characters.map({String($0)})
               
                for (index, valueLabel) in valueLabels.enumerated() {
                   
                    if let text = strings[safe: index] {
                        valueLabel.text = text
                        valueLabel.textColor = textColor
                        
                        if let activeColor = underLineActiveColor {
                            underLineViews[safe: index]?.backgroundColor = activeColor
                        }
                        
                    } else {
                        valueLabel.text = placeholderSymbol
                        valueLabel.textColor = placeholderTextColor

                        if underLineActiveColor != nil {
                            underLineViews[safe: index]?.backgroundColor = underLinePassiveColor
                        }
                    }
                }
                
                if valueCount == valueLabels.count {
                    delegate?.pinCodeDidFill(withValue: resultText)
                }
            }
        }
        return result
        
    }
    
    
    

    
}
