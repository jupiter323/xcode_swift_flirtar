//
//  MessageViewCell.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation


protocol MessageViewCellDelegate: class {
    func videoTap(link: String)
    func imageTap(imageView: UIImageView)
    func openProfile(profileId: Int)
}

class MessageViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    let textView: CenteredTextView = {
        let messageView = CenteredTextView()
        messageView.font = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        messageView.backgroundColor = UIColor.clear
        messageView.textColor = UIColor(red: 62/255, green: 67/255, blue: 79/255, alpha: 1.0)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.isEditable = false
        messageView.isScrollEnabled = false
        messageView.textContainerInset = UIEdgeInsets.zero
        messageView.textContainer.lineFragmentPadding = 0
        
        return messageView
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Play", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "playButton"), for: .normal)
        button.tintColor = UIColor.white
        
        return button
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let imageAttachment: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    //MARK: - Constraints
    var bubleWidth : NSLayoutConstraint?
    var bubleRight : NSLayoutConstraint?
    var bubleLeft: NSLayoutConstraint?
    var attachmentImageHeight: NSLayoutConstraint?
    
    //MARK: - Variables
    fileprivate var message: Message!
    weak var delegate: MessageViewCellDelegate?
    
    //MARK:  - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImage)
        bubbleView.addSubview(imageAttachment)
        bubbleView.addSubview(playButton)
        
        setupConstraints()
        
    }
    
    
    
    //MARK: - Public
    func configureCell(withMessage message: Message) {
        
        self.message = message
        
        setupLayers()
        
        if let messageText = message.messageText {
            textView.text = messageText
        }
        
        fillAttachment(message: message)
        fillPhoto(message: message)
        
        setupMessagePosition(message: message)
        
    }
    
    
    //MARK: - Helpers
    
    //MARK: Configuration layers
    fileprivate func setupConstraints() {
        //profile image view contraints
        NSLayoutConstraint(item: profileImage, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 10.0).isActive = true
        NSLayoutConstraint(item: profileImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: profileImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0.0, constant: 50.0).isActive = true
        NSLayoutConstraint(item: profileImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 50.0).isActive = true
        
        //buble view contraints
        bubleRight = NSLayoutConstraint(item: bubbleView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -10.0)
        bubleRight?.isActive = true
        
        bubleLeft = NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: profileImage, attribute: .right, multiplier: 1.0, constant: 10.0)
        bubleLeft?.isActive = false
        
        NSLayoutConstraint(item: bubbleView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        bubleWidth = NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0.0, constant: 200)
        bubleWidth?.isActive = true
        NSLayoutConstraint(item: bubbleView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
        
        //text view contraints
        NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1.0, constant: 20.0).isActive = true
        NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: imageAttachment, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1.0, constant: -20.0).isActive = true
        NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: bubbleView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        
        //image attachment
        NSLayoutConstraint(item: imageAttachment, attribute: .left, relatedBy: .equal, toItem: bubbleView, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageAttachment, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: imageAttachment, attribute: .right, relatedBy: .equal, toItem: bubbleView, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
        attachmentImageHeight = NSLayoutConstraint(item: imageAttachment, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.0)
        attachmentImageHeight?.isActive = true
        
        
        //video button
        NSLayoutConstraint(item: playButton, attribute: .centerX, relatedBy: .equal, toItem: imageAttachment, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: playButton, attribute: .centerY, relatedBy: .equal, toItem: imageAttachment, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: playButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 40.0).isActive = true
        NSLayoutConstraint(item: playButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40.0).isActive = true
        
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        imageAttachment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageZoomTap)))
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfile)))
    }
    
    private func setupLayers() {
        bubbleView.layoutIfNeeded()
        textView.layoutIfNeeded()

        profileImage.ovalImage()
        
//        profileImage.layoutIfNeeded()
//        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
//        profileImage.clipsToBounds = true
        
        playButton.isHidden = true
    }
    
    //MARK: Configuration data
    
    private func fillAttachment(message: Message) {
        if let messageAttachment = message.fileUrl {
            
            if let fileType = message.fileType {
                switch fileType {
                case .image:
                    let imageUrl = URL(string: messageAttachment)
                    imageAttachment.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
                case .video:
                    playButton.isHidden = false
                    let thumbnailImage = message.thumbnailImageUrl ?? ""
                    let imageUrl = URL(string: thumbnailImage)
                    imageAttachment.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
                }
            }
            
        }
    }
    
    private func fillPhoto(message: Message) {
        if message.sender?.id != ProfileService.savedUser?.userID {
            if let imageLink = message.sender?.photo {
                let imageUrl = URL(string: imageLink)
                profileImage.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            } else {
                profileImage.image = #imageLiteral(resourceName: "placeholder")
            }
        }
    }
    
    private func setupMessagePosition(message: Message) {
        
        let senderId = message.sender?.id ?? 0
        let currentUserId = ProfileService.savedUser?.userID ?? -1
        
        //your message
        if senderId == currentUserId {
            self.bubbleView.backgroundColor = UIColor(red: 234/255,
                                                      green: 236/266,
                                                      blue: 241/255,
                                                      alpha: 0.3)
            self.bubbleView.layer.borderWidth = 1.0
            self.bubbleView.layer.borderColor = UIColor.clear.cgColor
            self.profileImage.isHidden = true
            self.bubleRight?.isActive = true
            self.bubleLeft?.isActive = false
        } else {
            //to you message
            self.bubbleView.backgroundColor = UIColor.white
            self.bubbleView.layer.borderWidth = 1.0
            self.bubbleView.layer.borderColor = UIColor(red: 166/255,
                                                        green: 172/266,
                                                        blue: 185/255,
                                                        alpha: 1.0).cgColor
            self.profileImage.isHidden = false
            self.bubleRight?.isActive = false
            self.bubleLeft?.isActive = true
        }
    }
    
    
    //MARK: Handlers
    func imageZoomTap(tapGesture: UITapGestureRecognizer) {
        
        imageAttachment.layoutIfNeeded()
        
        if let imageView = tapGesture.view as? UIImageView {
            delegate?.imageTap(imageView: imageView)
        }
    }
    
    func playVideo() {
        guard let videoUrl = message.fileUrl else {
            return
        }
        delegate?.videoTap(link: videoUrl)
    }
    
    func openProfile() {
        guard let profileId = message.sender?.id else {
            return
        }
        delegate?.openProfile(profileId: profileId)
    }
    
    
}












