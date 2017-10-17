//
//  MessagesLikesViewCell.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SDWebImage

class MessagesLikesViewCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var imageBack: UIView!
    
    //MARK: - UICollectionViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    //MARK: - Public
    func configureCell(withLike like: ShortUser) {
        
        self.layoutIfNeeded()
        photoView.layoutIfNeeded()
        imageBack.layoutIfNeeded()
        photoView.ovalImage()
        
        let centerPoint = photoView.center
        let defaultRadius = photoView.bounds.height / 2
        let mainColor = UIColor.white.cgColor
        let subColor = UIColor(red: 74/255,
                               green: 144/255,
                               blue: 226/255,
                               alpha: 1.0).cgColor
        
        imageBack.addCircle(centerPoint: centerPoint,
                            radius: defaultRadius + 1,
                            color: mainColor,
                            width: 1.0)
        
        imageBack.addCircle(centerPoint: centerPoint,
                            radius: defaultRadius + 4,
                            color: subColor,
                            width: 2.0)
        
        if let imageLink = like.photos.first?.url {
            let imageUrl = URL(string: imageLink)
            photoView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            photoView.image = #imageLiteral(resourceName: "placeholder")
        }
        
    }
    
}
