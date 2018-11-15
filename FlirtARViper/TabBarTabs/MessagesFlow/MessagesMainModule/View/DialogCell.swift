//
//  DialogCell.swift
//  FlirtARViper
//
//  Created by   on 05.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import SDWebImage
import SWTableViewCell

class DialogCell: SWTableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoBack: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    
    //MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayers()
    }
    
    
    //MARK: - Public
    func configureCell(withDialog dialog: Dialog) {

        usernameLabel.text = dialog.user?.firstName ?? "No data"
        
        fillPhoto(dialog: dialog)
        fillUnreadCountView(dialog: dialog)
        fillDate(dialog: dialog)
        fillMessageText(dialog: dialog)
        
    }
    
    //MARK: - Private
    
    //MARK: Configuration layers
    private func setupLayers() {
        
        photoView.ovalImage()
        notificationView.round()
    }
    
    //MARK: Configuration data
    fileprivate func fillPhoto(dialog: Dialog) {
        if let photoString = dialog.user?.photos.first?.thumbnailUrl {
            let imageURL = URL(string: photoString)
            photoView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            photoView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
    fileprivate func fillUnreadCountView(dialog: Dialog) {
        if let unreadCounter = dialog.unreadCount {
            if unreadCounter != 0 {
                notificationView.isHidden = false
                notificationLabel.text = "\(unreadCounter)"
            } else {
                notificationView.isHidden = true
                notificationLabel.text = ""
            }
        } else {
            notificationView.isHidden = true
            notificationLabel.text = ""
        }
    }
    
    fileprivate func fillDate(dialog: Dialog) {
        if let messageDate = dialog.message?.created {
            let nowDate = Date()
            let days = nowDate.days(from: messageDate)
            let hours = nowDate.hours(from: messageDate)
            
            if hours < 24 {
                //time here
                dateLabel.text = DateFormatter.HMDateFormatter.string(from: messageDate)
            } else if days >= 0 && days <= 1 {
                dateLabel.text = "yesterday"
            } else {
                //date
                dateLabel.text = DateFormatter.DMYFormatter.string(from: messageDate)
            }
        } else {
            dateLabel.text = ""
        }
    }
    
    fileprivate func fillMessageText(dialog: Dialog) {
        guard let messageText = dialog.message?.messageText else {
                return
        }
        
        let messageAttachmentLink = dialog.message?.fileUrl ?? ""
        
        photoBack.removeShapeLayers()
        
        //new chat
        if messageText.isEmpty && messageAttachmentLink.isEmpty {
            messageLabel.text = "New chat"
            messageLabel.textColor = UIColor(red: 234/255, green: 236/255, blue: 241/255, alpha: 1.0)
            photoBack.layoutIfNeeded()
            photoBack.addCircle(centerPoint: photoView.center,
                                radius: photoView.bounds.height / 2 + 1,
                                color: UIColor(red: 201/255,
                                               green: 35/255,
                                               blue: 61/255,
                                               alpha: 1.0).cgColor,
                                width: 2.0)
            //only attachment
        } else if messageText.isEmpty && !messageAttachmentLink.isEmpty {
            messageLabel.text = "Attachment"
            messageLabel.textColor = UIColor(red: 122/255, green: 128/255, blue: 142/255, alpha: 1.0)
        } else {
            messageLabel.text = messageText
            messageLabel.textColor = UIColor(red: 122/255, green: 128/255, blue: 142/255, alpha: 1.0)
        }
    }
    
}
