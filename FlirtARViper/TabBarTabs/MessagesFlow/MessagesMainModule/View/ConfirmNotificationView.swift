//
//  RemoveDialogView.swift
//  FlirtARViper
//
//  Created by  on 23.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol ConfirmNotificationViewDelegate: class {
    func confirmTap()
    func cancelTap()
}

class ConfirmNotificationView: ViewFromXIB {
    
    //MARK: - Outlets
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var confirmButton: RoundedButton!
    
    weak var delegate: ConfirmNotificationViewDelegate?
    
    //MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureView(withTitle title: String,
                       subTitle subtitle: String,
                       confirmButton confirmTitle: String) {
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        confirmButton.setTitle(confirmTitle, for: .normal)
        
        self.view!.superview?.backgroundColor = UIColor.clear
        
        roundedView.layoutIfNeeded()
        roundedView.layer.cornerRadius = 5.0
    }
    
    
    //MARK: - Actions
    @IBAction func cancelButtonTap(_ sender: Any) {
        delegate?.cancelTap()
    }
    
    
    @IBAction func confirmButtonTap(_ sender: Any) {
        delegate?.confirmTap()
    }
    
    
    
    
}
