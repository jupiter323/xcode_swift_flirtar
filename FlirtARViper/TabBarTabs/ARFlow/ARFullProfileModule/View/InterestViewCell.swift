//
//  InterestViewCell
//  FlirtARViper
//
//  Created by on 05.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class InterestViewCell: UICollectionViewCell {

    @IBOutlet weak var interestView: InterestItemView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(withInterest interest: String,
                       maxFontSize size: CGFloat,
                       fontColor color: UIColor,
                       fontName: String) {
        interestView.title = interest
        interestView.itemTextColor = color
        interestView.itemTextFont = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
