//
//  RateAppNotificationView.swift
//  FlirtARViper
//
//  Created by  on 05.10.2017.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class RateAppNotificationView: ViewFromXIB {

    //MARK: - Outlets
    
    @IBOutlet weak var starsControl: RatingControl!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var messageRoundedView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    //MARK: - Variables
    fileprivate var messagePlaceholderText = "Optional"
    fileprivate var mainTextColor = UIColor(red: 62/255,
                                            green: 67/255,
                                            blue: 79/255,
                                            alpha: 1.0)
    fileprivate var placeholderTextColor = UIColor(red: 122/255,
                                                   green: 128/255,
                                                   blue: 142/255,
                                                   alpha: 1.0)
    fileprivate var isNeedToOpenAppStore = false
    
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureView(withTitle title: String,
                       subTitle subtitle: String,
                       openAppStore isNeed: Bool) {
        self.view!.superview?.backgroundColor = UIColor.clear
        starsControl.rating = 1
        
        roundedView.layoutIfNeeded()
        roundedView.layer.cornerRadius = 5.0
        
        
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
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        isNeedToOpenAppStore = isNeed
        
        starsControl.rating = 5
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonTap(_ sender: Any) {
        closeView()
    }
    
    @IBAction func rateButtonTap(_ sender: Any) {
        
        var comment = ""
        if messageTextView.text != messagePlaceholderText {
            comment = messageTextView.text
        }
        
        let request = APIRouter.sendFeedback(rate: starsControl.rating,
                                             comment: comment)
        
        NetworkManager.shared.sendAPIRequestWithStringResponse(request: request) { (error) in
            
            if self.isNeedToOpenAppStore {
                if let url = URL(string: ExternalLinks.itunesLink.rawValue),
                    UIApplication.shared.canOpenURL(url){
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url,
                                                  options: [:],
                                                  completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                }
            }
            
            DispatchQueue.main.async {
                self.closeView()
            }
            
        }
    }
    
    //MARK: - Helpers
    private func closeView() {
        self.removeFromSuperview()
    }
    
    
}

extension RateAppNotificationView: UITextViewDelegate {
    
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
