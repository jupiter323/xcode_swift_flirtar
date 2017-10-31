//
//  MessagesDetailViewController.swift
//  FlirtARViper
//
//  Created by  on 17.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD
import IQKeyboardManagerSwift
import AVFoundation
import AVKit
import MobileCoreServices
import Alamofire
import SwiftWebSocket
import XLActionController


class MessagesDetailViewController: UIViewController, MessagesDetailViewProtocol, UINavigationControllerDelegate {

    //MARK: - Outlets
    @IBOutlet weak var messagesView: UICollectionView!
    
    @IBOutlet weak var customInputView: UIView!
    @IBOutlet weak var inputBackground: UIView!
    @IBOutlet weak var newMessageView: UITextView!
    @IBOutlet weak var attachmentsView: UIView!
    @IBOutlet weak var attachmentImage: UIImageView!
    
    @IBOutlet var attachmentsShowContraint: NSLayoutConstraint!
    @IBOutlet var attachmentsHideConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomInputConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightInputConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Variables
    fileprivate var messages = [Message]()
    fileprivate var initialInit = true
    fileprivate var placeholderText = "Type a message..."
    fileprivate var placeholderColor = UIColor(red: 166/255,
                                               green: 172/255,
                                               blue: 185/255,
                                               alpha: 0.5)
    fileprivate var mainTextColor = UIColor(red: 62/255,
                                            green: 67/255,
                                            blue: 79/255,
                                            alpha: 1.0)
    
    fileprivate var reloadController = true
    fileprivate var initialReportY: CGFloat = 0.0
    
    fileprivate var attachments = [LocalAttachment]() {
        didSet {
            if attachments.count != 0 {
                
                attachmentsView.isHidden = false
                
                if let attachmentUIImage = attachments.first?.image {
                    attachmentImage.image = attachmentUIImage
                } else {
                    attachmentImage.image = #imageLiteral(resourceName: "placeholder")
                }
                
                
                
                attachmentsShowContraint.isActive = true
                attachmentsHideConstraint.isActive = false
            } else {
                
                attachmentsView.isHidden = true
                attachmentImage.image = nil
                attachmentsShowContraint.isActive = false
                attachmentsHideConstraint.isActive = true
            }
            
            view.layoutIfNeeded()
        }
    }
    
    fileprivate var zoomView: UIImageView?
    fileprivate var blackBackground: UIView?
    fileprivate var startImageFrame: CGRect?
    fileprivate var refreshControl = UIRefreshControl()
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputViews()
        configureTextInputView()
        configureCollectionView()
        configureRefreshControl()
        configureTopBar()
        
        
    }
    
    private func configureInputViews() {
        inputBackground.layoutIfNeeded()
        inputBackground.layer.cornerRadius = 25.0
        inputBackground.layer.borderWidth = 1.0
        inputBackground.layer.borderColor = UIColor(red: 166/255,
                                                    green: 172/255,
                                                    blue: 185/255,
                                                    alpha: 0.5).cgColor
        inputBackground.clipsToBounds = true
        
        attachmentImage.layoutIfNeeded()
        attachmentImage.layer.cornerRadius = 5.0
        attachmentImage.clipsToBounds = true
        
        attachmentsView.isHidden = true
    }
    
    private func configureTextInputView() {
        newMessageView.layoutIfNeeded()
        newMessageView.textContainerInset = UIEdgeInsets(top: 6.5, left: 0, bottom: 0, right: 0)
        newMessageView.textContainer.lineFragmentPadding = 0
        
        newMessageView.text = placeholderText
        newMessageView.textColor = placeholderColor
    }
    
    private func configureCollectionView() {
        messagesView.register(MessageViewCell.self, forCellWithReuseIdentifier: "messageViewCell")
        messagesView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(downloadMoreMessages(_:)), for: .valueChanged)
        let refreshColor = UIColor(red: 166/255, green: 172/255, blue: 185/255, alpha: 1.0)
        let refteshFont = UIFont(name: "VarelaRound", size: 12.0) ?? UIFont.systemFont(ofSize: 12.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading history..."
            , attributes: [NSForegroundColorAttributeName: refreshColor,
                           NSFontAttributeName: refteshFont])
        
        if #available(iOS 10.0, *) {
            messagesView.refreshControl = refreshControl
        } else {
            messagesView.backgroundView = refreshControl
        }
        
        refreshControl.layoutIfNeeded()
    }
    
    private func configureTopBar() {
        
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTopBarTitleTap)))
        
        
    }
    
    
    @objc private func downloadMoreMessages(_ refreshControl: UIRefreshControl) {
        presenter?.loadMoreMessages()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(true)
        
        if reloadController {
            presenter?.viewWillAppear()
        } else {
            reloadController = true
        }
        
        IQKeyboardManager.sharedManager().enable = false
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(false)
        
        IQKeyboardManager.sharedManager().enable = true
        
        NotificationCenter.default.removeObserver(self)
        
        SocketManager.shared.closeMessageSocket()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    @IBAction func addAttachmentTap(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String,
                                            kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func removeAttachmentTap(_ sender: Any) {
        attachments = [LocalAttachment]()
    }
    
    @IBAction func moreOptionTap(_ sender: Any) {
        let alertController = YoutubeActionController()
        
        alertController.addAction(Action(ActionData(title: "Block User"), style: .default, handler: { action in
            
            self.presenter?.blockUser()
            
        }))
        alertController.addAction(Action(ActionData(title: "Report"), style: .default, handler: { action in
            self.showReportNotification()
        }))
        alertController.addAction(Action(ActionData(title: "Cancel"), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendButtonTap(_ sender: Any) {
        
        //get attachment
        let attachment = attachments.first
        
        //if attachment not exist and text is empty -> not send
        if attachment == nil && (newMessageView.text == placeholderText || newMessageView.text.isEmpty) {
            return
        }
        
        //if only attachment exist
        if attachment != nil && (newMessageView.text == placeholderText || newMessageView.text.isEmpty) {
            //send only attachment
            presenter?.sendMessage(withText: "",
                                   attachment: attachment)
            //clear
            resetInputView()
        } else {
            //send text and attachment
            presenter?.sendMessage(withText: newMessageView.text,
                                   attachment: attachment)
            //clear
            resetInputView()
        }
        
    }
    
    
    
    //MARK: - MessagesDetailViewProtocol
    
    var presenter: MessagesDetailPresenterProtocol?
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage) {
        HUD.show(.labeledProgress(title: withType.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
        refreshControl.endRefreshing()
    }
    
    func showError(errorMessage: String) {
        HUD.show(.labeledError(title: "Error", subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func showMessages(messages: [Message]) {
        self.messages = messages
        messagesView.reloadData()
        
        if initialInit {
            messagesView.scrollToBottom()
            messagesView.layoutIfNeeded()
            initialInit = false
        }
        
    }
    
    func fillGeneralInfo(withUser user: ShortUser) {
        nameLabel.text = user.firstName ?? "No data"
    }
    
    func appendNewMessage(message: Message) {
        
        messagesView.layoutIfNeeded()
        let visibleRows = messagesView.indexPathsForVisibleItems
        
        var founded = false
        
        for eachRow in visibleRows {
            if eachRow.row == messages.count - 1 {
                self.messages.append(message)
                messagesView.reloadData()
                messagesView.scrollToBottom()
                founded = true
                break
            }
        }
        
        if !founded {
            self.messages.append(message)
            messagesView.reloadData()
        }
        
    }
    
    func appendMoreMessages(messages: [Message]) {
        self.messages.insert(contentsOf: messages, at: 0)
        messagesView.reloadData()
        messagesView.layoutIfNeeded()
        refreshControl.endRefreshing()
    }
    
    func showUserBlocked() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let blockAlert = TextNotificationView(frame: UIScreen.main.bounds)
        blockAlert.configureView(withText: TextNotificationViewTexts.userBlocked.rawValue)
        blockAlert.backgroundColor = UIColor(red: 62/255,
                                             green: 67/255,
                                             blue: 79/255,
                                             alpha: 0.7)
        mainView?.addSubview(blockAlert)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            blockAlert.removeFromSuperview()
        }
    }
    
    func showUserReported() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let blockAlert = TextNotificationView(frame: UIScreen.main.bounds)
        blockAlert.configureView(withText: TextNotificationViewTexts.userReported.rawValue)
        blockAlert.backgroundColor = UIColor(red: 62/255,
                                             green: 67/255,
                                             blue: 79/255,
                                             alpha: 0.7)
        mainView?.addSubview(blockAlert)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            blockAlert.removeFromSuperview()
        }
    }
    
    
    
    //MARK: - Helpers
    //hide keyboard
    func keyboardWillHide(notification: Notification) {
        if let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double {
            
            bottomInputConstraint.constant = 0
            
            
            UIView.animate(withDuration: keyboardAnimationDuration, animations: { 
                self.view.layoutIfNeeded()
            })
            
            guard let lastSubview = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view.subviews.last else {
                return
            }
            
            if lastSubview is ReportNotificationView {
                lastSubview.frame = UIScreen.main.bounds
            }
            
        }
        
    }
    
    //show keyboard
    func keyboardWillShow(notification: Notification) {
        if let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            
            bottomInputConstraint.constant = keyboardFrame.height
            
            
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
            
            
            messagesView.scrollToBottom()
            messagesView.layoutIfNeeded()
            
            guard let lastSubview = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view.subviews.last else {
                return
            }
            
            if lastSubview is ReportNotificationView && UIScreen.main.bounds.height <= 568.0 {
                lastSubview.frame.origin.y = initialReportY - 80.0
            }
            
            
        }
    }
    
    
    //handler zoom out from zoomIn
    func imageZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutView = tapGesture.view {
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            
                            let rectShape = CAShapeLayer()
                            rectShape.bounds = zoomOutView.frame
                            rectShape.position = zoomOutView.center
                            
                            let frameForShape = CGRect(x: zoomOutView.frame.minX, y: zoomOutView.frame.minY, width: 200, height: 200)
                            
                            rectShape.path = UIBezierPath(roundedRect: frameForShape, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
                            
                            zoomOutView.layer.mask = rectShape
                            
                            
                            zoomOutView.contentMode = .scaleAspectFill
                            zoomOutView.frame = self.startImageFrame!
                            self.blackBackground?.alpha = 0.0
                
            }, completion: { (isCompleted: Bool) in
                zoomOutView.removeFromSuperview()
                self.zoomView?.isHidden = false
            })
            
        }
    }
    
    private func resetInputView() {
        if newMessageView.isFirstResponder {
            newMessageView.text = ""
        } else {
            newMessageView.text = placeholderText
            newMessageView.textColor = placeholderColor
        }
        
        heightInputConstraint.constant = 60.0
        attachments = [LocalAttachment]()
        messagesView.layoutIfNeeded()
        messagesView.scrollToBottom()
    }
    
    func hideReportNotification() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let lastView = mainView?.subviews.last
        lastView?.removeFromSuperview()
    }
    
    func showReportNotification() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let reportNotification = ReportNotificationView(frame: UIScreen.main.bounds)
        reportNotification.configureView()
        reportNotification.delegate = self
        initialReportY = reportNotification.frame.origin.y
        mainView?.addSubview(reportNotification)
    }
    
    func handleTopBarTitleTap() {
        presenter?.openProfile(profileId: nil)
    }

}

//MARK: - ReportNotificationDelegate
extension MessagesDetailViewController: ReportNotificationDelegate {
    func sendTap(withText: String) {
        hideReportNotification()
        presenter?.reportUser(withText: withText)
    }
    
    func cancelReportTap() {
        hideReportNotification()
    }
}

//MARK: - UITextViewDelegate
extension MessagesDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let font = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        let newRect = textView.text.estimateFrameForText(font: font, width: newMessageView.bounds.width)
        
        let newValue = newRect.height + 36.0
        
        if newValue > 60.0 && newValue < 120.0 {
            heightInputConstraint.constant = newValue
        } else if newValue > 120.0  {
            heightInputConstraint.constant = 120.0
        } else if newValue < 60.0 {
            heightInputConstraint.constant = 60.0
        }
        
        newMessageView.layoutIfNeeded()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == placeholderText)
        {
            textView.text = ""
            textView.textColor = mainTextColor
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "")
        {
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
        textView.resignFirstResponder()
    }
}




//MARK: - UICollectionViewDataSource
extension MessagesDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageViewCell", for: indexPath) as? MessageViewCell
        guard cell != nil else {
            return UICollectionViewCell()
        }
        
        cell?.configureCell(withMessage: messages[indexPath.row])
        cell?.delegate = self
        
        let text = messages[indexPath.row].messageText ?? ""
        let attachment = messages[indexPath.row].fileUrl ?? ""
        let font = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        let rect = text.estimateFrameForText(font: font, width: 200.0)
        
        
        
        if attachment.isEmpty {
            cell!.attachmentImageHeight?.constant = 0.0
            //40 = 20 left textView layout constant + 20 right
            cell!.bubleWidth?.constant = rect.width + 42.0
        } else {
            cell!.attachmentImageHeight?.constant = 200.0
            cell!.bubleWidth?.constant = 200.0
        }
        
        return cell!
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MessagesDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height : CGFloat = 50.0
        let width: CGFloat = 200.0
        
        let text = messages[indexPath.row].messageText ?? ""
        let attachment = messages[indexPath.row].fileUrl ?? ""
        let font = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        let textRect = text.estimateFrameForText(font: font, width: width)
        
        //16 - top Constraint for textView + 16 for bottom
        //only text
        if attachment.isEmpty {
            height = textRect.height + 32.0
            //only attachment
        } else if !attachment.isEmpty && text.isEmpty {
            height = 200.0
            //attachment and text
        } else {
            height = textRect.height + 32.0 + 200.0
        }
        
        return CGSize(width: view.frame.width, height: height)
        
    }
}

//MARK: - MessageViewCellDelegate
extension MessagesDetailViewController: MessageViewCellDelegate {
    
    //open profile info
    func openProfile(profileId: Int) {
        presenter?.openProfile(profileId: profileId)
        reloadController = false
    }
    
    //play video in new controller full screen
    func videoTap(link: String) {
        if let urlString = URL(string: link) {
            let player = AVPlayer(url: urlString)
            player.play()
            
            let fullScreenPlayerController = AVPlayerViewController()
            fullScreenPlayerController.player = player
            present(fullScreenPlayerController, animated: true, completion: nil)
            
            reloadController = false
            
        }
    }
    
    //image zoom in
    func imageTap(imageView: UIImageView) {
        zoomView = imageView
        zoomView?.isHidden = true
        
        startImageFrame = imageView.superview?.convert(imageView.frame, to: nil)
        
        
        let zoomImageView = UIImageView(frame: startImageFrame!)
        zoomImageView.image = imageView.image
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.clipsToBounds = true
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageZoomOut)))
        
        if let mainWindow = UIApplication.shared.keyWindow {
            blackBackground = UIView(frame: mainWindow.frame)
            blackBackground?.backgroundColor = UIColor.black
            blackBackground?.alpha = 0.0
            
            mainWindow.addSubview(blackBackground!)
            mainWindow.addSubview(zoomImageView)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: { 
                            
                            self.blackBackground?.alpha = 1.0
                            
                            zoomImageView.frame = mainWindow.frame
                            zoomImageView.center = mainWindow.center
                            
                            
            },
                           completion: nil)
            
            
        }
        
        
    }
}


//MARK: - UIImagePickerController
extension MessagesDetailViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //selected video
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            print(videoUrl)
            
            let asset = AVAsset(url: videoUrl)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
                
                let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
                
                let videoAttachment = LocalAttachment(type: .video,
                                                      image: uiImage,
                                                      videoURL: videoUrl)
                
                attachments = [videoAttachment]
            } catch let err {
                print(err.localizedDescription)
            }
            
        }
        
        
        
        
        //selected photo
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            let photoAttachment = LocalAttachment(type: .image,
                                                  image: selectedImage,
                                                  videoURL: nil)
            
            attachments = [photoAttachment]
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

