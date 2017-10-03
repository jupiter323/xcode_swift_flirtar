//
//  String+Extensions.swift
//  FlirtARViper
//
//  Created by  on 01.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit


extension String {
    
    func isValidEmail() -> Bool {
        print("validate emilId: \(self)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        
        return result
    }
    
    func isValidPassword() -> Bool {
        if self.characters.count < 7 {
            return false
        }
        print("validate pswd: \(self)")
        let pswdRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        let pswdTest = NSPredicate(format:"SELF MATCHES %@", pswdRegEx)
        
        let result = pswdTest.evaluate(with: self)
        
        return result
    }
    
    func estimateFrameForText(font: UIFont, width: CGFloat) -> CGRect {
        
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let font = font
        
        return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: font], context: nil)
        
    }
    
    static func formattedString(from date: Date) -> String {
        return DateFormatter.inputViewDateFormatter.string(from: date)
    }
    
    func badWordsFilter() -> Bool {
        let badWords = ["first", "second", "third"]
        return badWords.reduce(false) {$0 || self.contains($1.lowercased())}
    }
    
    
}
