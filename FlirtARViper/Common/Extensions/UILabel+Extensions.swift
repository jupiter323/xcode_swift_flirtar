//
//  UILabel+Extensions.swift
//  FlirtARViper
//
//  Created by on 05.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation

extension UILabel {
    
    func addReadMoreText(with trailingText: String,
                     moreText: String,
                     moreTextFont: UIFont,
                     moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let visibleTextParameters = self.vissibleTextLength()
        let lengthForVisibleString: Int = visibleTextParameters.count
        let isAllTextIsVisible: Bool = visibleTextParameters.allTextIsVisible
        let mutableString: String = self.text!
        
        //if all text is visible -> return bo nothing
        if isAllTextIsVisible {
            return
        }
        
        //if full text shorter than visible -> return do nothing
        if mutableString.characters.count < lengthForVisibleString {
            return
        }
        
        
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.characters.count)! - lengthForVisibleString)), with: "")
        
        
        let readMoreLength: Int = (readMoreText.characters.count)
        
        //if trimmedstring shorter than readmoretext -> return
        if (trimmedString?.characters.count ?? 0) < readMoreLength {
            return
        }
        
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.characters.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSFontAttributeName: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSFontAttributeName: moreTextFont, NSForegroundColorAttributeName: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    func vissibleTextLength() -> (count: Int, allTextIsVisible: Bool) {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSFontAttributeName: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [String : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.characters.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.characters.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [String : Any], context: nil).size.height <= labelHeight
            return (prev, false)
        }
        return (self.text!.characters.count, true)
    }
}
