//
//  TitledCell.swift
//  FlirtARViper
//
//  Created by  on 07.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol TitledCellDelegate: class {
    func logoutTap()
    func blockedUsersTap()
    func rateAppStoreTap()
    func rateCustomTap()
}

//all methods optional
extension TitledCellDelegate {
    func logoutTap() {}
    func blockedUsersTap() {}
    func rateAppStoreTap() {}
    func rateCustomTap() {}
}

class TitledCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!

    //MARK: - Variables
    private var cellType: CellConfiguration?
    weak var delegate: TitledCellDelegate?
    
    //MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            guard cellType != nil else {
                return
            }
            
            switch cellType! {
            case .Account(.logout):
                delegate?.logoutTap()
            case .Account(.blockUsers):
                delegate?.blockedUsersTap()
            case .Feedback(.rateAppStore):
                delegate?.rateAppStoreTap()
            case .Feedback(.customRate):
                delegate?.rateCustomTap()
            default:
                break
            }
        }
        
    }
    
    func configureCell(withType type: CellConfiguration) {
        switch type {
        case .Account(.logout):
            titleLabel.text = "Logout"
        case .Account(.blockUsers):
            titleLabel.text = "Blocked Users"
        case .Feedback(.rateAppStore):
            titleLabel.text = "Rating Us on App Store"
        case .Feedback(.customRate):
            titleLabel.text = "Do you like our app?"
        default:
            break
        }
        cellType = type
    }
    
}
