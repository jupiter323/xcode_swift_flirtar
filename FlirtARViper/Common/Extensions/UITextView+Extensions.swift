//
//  UITextView+Extensions.swift
//  FlirtARViper
//
//  Created by on 19.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

extension UITextView {
    func addLink(forText linkText: String, url: URL) {
        
        guard let text = self.attributedText else {
            return
        }
        
        let rangeForLinkText = (text.string as NSString).range(of: linkText)
        let font = UIFont(name: "VarelaRound", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
        
        let linkAttributes =
            [NSLinkAttributeName: url,
             NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: font,
             NSUnderlineColorAttributeName: UIColor.white,
             NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
        
        
        let changeableText = NSMutableAttributedString(attributedString: text)
        changeableText.setAttributes(linkAttributes, range: rangeForLinkText)
        
        self.attributedText = changeableText
        
    }
}
