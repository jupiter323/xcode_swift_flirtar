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
        default:
            break
        }
        cellType = type
    }
    
}
