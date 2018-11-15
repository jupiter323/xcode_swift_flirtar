//
//  PhotoViewCell.swift
//  FlirtARViper
//
//  Created by  on 03.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {

    //MARK: - Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoTitle: PhotoLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(withPhoto photo: UIImage, row: Int, allPhotos: Int) {
        
        if row == 0 {
            photoTitle.text = "\(row + 1)/\(allPhotos) Title photo"
        } else {
            photoTitle.text = "\(row + 1)/\(allPhotos)"
        }
        photoView.image = photo
    }

}
