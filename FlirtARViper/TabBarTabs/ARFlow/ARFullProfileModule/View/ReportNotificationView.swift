//
//  ReportNotificationView.swift
//  FlirtARViper
//
//  Created by on 06.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol ReportNotificationDelegate: class {
    func sendTap(withText: String)
    func cancelReportTap()
}


class ReportNotificationView: ViewFromXIB {

    //MARK: - Outlets
    @IBOutlet weak var roundedMainView: UIView!
    @IBOutlet weak var messageRoundedView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    
    weak var delegate: ReportNotificationDelegate?
    fileprivate var messagePlaceholderText = "Your Message"
    fileprivate var mainTextColor = UIColor(red: 62/255,
                                            green: 67/255,
                                            blue: 79/255,
                                            alpha: 1.0)
    fileprivate var placeholderTextColor = UIColor(red: 122/255,
                                                   green: 128/255,
                                                   blue: 142/255,
                                                   alpha: 1.0)
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureView() {
        
        self.view!.superview?.backgroundColor = UIColor.clear
        
        roundedMainView.layoutIfNeeded()
        roundedMainView.layer.cornerRadius = 5.0
        
        messageRoundedView.layoutIfNeeded()
        messageRoundedView.layer.cornerRadius = 10.0
        messageRoundedView.layer.borderWidth = 1.0
        messageRoundedView.layer.borderColor = UIColor(red: 213/255,
                                                       green: 216/255,
                                                       blue: 224/255,
                                                       alpha: 1.0).cgColor
        
        messageTextView.text = messagePlaceholderText
        messageTextView.textColor = placeholderTextColor
        messageTextView.delegate = self
        
    }
    
    
    //MARK: - Actions
    @IBAction func cancelTap(_ sender: Any) {
        delegate?.cancelReportTap()
    }
    
    @IBAction func sendTap(_ sender: Any) {
        if messageTextView.text != messagePlaceholderText {
            delegate?.sendTap(withText: messageTextView.text)
        }
    }
    
    

}

extension ReportNotificationView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == messagePlaceholderText)
        {
            textView.text = ""
            textView.textColor = mainTextColor
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "")
        {
            textView.text = messagePlaceholderText
            textView.textColor = placeholderTextColor
        }
        textView.resignFirstResponder()
    }
}
