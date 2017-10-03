//
//  BlockedUserCell.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import SDWebImage

protocol BlockedUserCellDelegate: class {
    func unblockUser(withId: Int,
                     withRow: Int)
}

class BlockedUserCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unblockButton: BorderedButton!
    
    //MARK: - Variables
    weak var delegate: BlockedUserCellDelegate?
    var user: MarkerUser!
    
    //MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.ovalImage()
    }
    
    func configureCell(withType user: MarkerUser) {
        if let imageLink = user.photo {
            let imageUrl = URL(string: imageLink)
            profileImageView.sd_setImage(with: imageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        } else {
            profileImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        
        nameLabel.text = user.firstname ?? "No name"
        
        self.user = user
        
    }
    
    //MARK: - Actions
    @IBAction func unblockTap(_ sender: Any) {
        guard let userId = user.id else {
            return
        }
        
        delegate?.unblockUser(withId: userId,
                              withRow: unblockButton.tag)
    }
    
}
