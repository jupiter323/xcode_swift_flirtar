//
//  Array+Extensions.swift
//  FlirtARViper
//
//  Created by   on 02.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

extension Array where Element: UITextField {
    
    func emptyField() -> UITextField? {
        var result: UITextField?
        for textField in self {
            if let count = textField.text?.characters.count, count > 0 {
                continue
            }
            result = textField
            break
        }
        return result
    }
    
}

