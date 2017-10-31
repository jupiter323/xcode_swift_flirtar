//
//  InstagramPhotoViewCell.swift
//  FlirtARViper
//
//  Created by on 28.09.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SDWebImage

class InstagramPhotoViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    //MARK: - Variables
    fileprivate var zoomView: UIImageView?
    fileprivate var blackBackground: UIView?
    fileprivate var startImageFrame: CGRect?

    //MARK: Data
    fileprivate var photo: Photo?
    
    //MARK: - UICollectionView
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layoutIfNeeded()
        photoImageView.superview?.layoutIfNeeded()
        photoImageView.superview?.round(radius: 3.0)
        photoImageView.superview?.clipsToBounds = true
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageZoomTap)))
    }
    
    //MARK: - Configuration
    func configureWithPhotoString(photo: Photo) {
        self.photo = photo
        if let photoUrlString = photo.thumbnailUrl {
            let imageUrl = URL(string: photoUrlString)
            photoImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            photoImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        
    }
    
    //MARK: - Helpers
    //Handlers
    @objc private func imageZoomTap(tapGesture: UITapGestureRecognizer) {
        photoImageView.layoutIfNeeded()
        if let imageView = tapGesture.view as? UIImageView {
            
            zoomView = imageView
            zoomView?.isHidden = true
            
            startImageFrame = imageView.superview?.convert(imageView.frame, to: nil)
            
            let zoomImageView = UIImageView(frame: startImageFrame!)
            if let fullPhotoString = photo?.url {
                let url = URL(string: fullPhotoString)
                zoomImageView.sd_setImage(with: url, placeholderImage: imageView.image)
            } else {
                zoomImageView.image = imageView.image
            }
            zoomImageView.contentMode = .scaleAspectFit
            zoomImageView.clipsToBounds = true
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageZoomOut)))
            
            if let mainWindow = UIApplication.shared.keyWindow {
                blackBackground = UIView(frame: mainWindow.frame)
                blackBackground?.backgroundColor = UIColor(red: 62/255,
                                                           green: 67/255,
                                                           blue: 79/255,
                                                           alpha: 0.7)
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
    
    @objc private func imageZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutView = tapGesture.view {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            
                            zoomOutView.layer.cornerRadius = 3.0
                            zoomOutView.contentMode = .scaleAspectFill
                            zoomOutView.frame = self.startImageFrame!
                            self.blackBackground?.alpha = 0.0
                            
            }, completion: { (isCompleted: Bool) in
                zoomOutView.removeFromSuperview()
                self.zoomView?.isHidden = false
            })
        }
    }

}
