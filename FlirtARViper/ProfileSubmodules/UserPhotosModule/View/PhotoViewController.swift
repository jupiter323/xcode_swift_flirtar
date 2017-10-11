//
//  PhotoViewController.swift
//  FlirtARViper
//
//  Created by  on 08.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import SDWebImage

class PhotoViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoLabel: PhotoLabel!
    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func confugireView(withPhoto photo: Photo?,
                       andTitle title: String?,
                       andType containerType: PhotoContainerType?,
                       andDistance distance: CGFloat?) {
        
        if let containerType = containerType {
            switch containerType {
            case .arProfile:
                bottomLabelConstraint.constant = 115.0
            case .settingsProfile:
                bottomLabelConstraint.constant = 60.0
            }
        }
        
        if let distance = distance {
            bottomLabelConstraint.constant = distance
        }
        
        photoLabel.layoutIfNeeded()
        
        if let photo = photo {
            let photoLink = photo.url
            if photoLink != nil {
                let photoURL = URL(string: photoLink!)
                photoView.sd_setImage(with: photoURL, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
        } else {
            photoView.image = #imageLiteral(resourceName: "placeholder")
        }
        
        if let titleText = title {
            photoLabel.isHidden = false
            photoLabel.text = titleText
        } else {
            photoLabel.isHidden = true
        }
        
        
    }

}


