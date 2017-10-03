//
//  FBSwitchCell.swift
//  FlirtARViper
//
//  Created by   on 07.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit

protocol ImagedSwitchCellDelegate: class {
    func fbDisconnetion()
}

class ImagedSwitchCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var switchView: SwitchView!
    @IBOutlet weak var imageIndicator: UIImageView!
    
    //MARK: - Variables
    fileprivate var cellType: CellConfiguration?
    weak var delegate: ImagedSwitchCellDelegate?
    
    //MARK: - UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureCell(withType type: CellConfiguration, state: Bool) {
        switch type {
        case .Account(.fbSwitch):
            switchView.title = "Facebook connection"
            imageIndicator.image = #imageLiteral(resourceName: "facebookIndicator")
        default:
            break
        }
        cellType = type
        switchView.isOn = state
        
        if state == false {
            switchView.isUserInteractionEnabled = false
        }
        
    }
    
    
    
}

extension ImagedSwitchCell: SwitchViewDelegate {
    func valueChanged(switchView: SwitchView) {
        guard cellType != nil else {
            return
        }
        
        switch cellType! {
        case .Account(.fbSwitch):
            
            
            if switchView.isOn {
                switchView.setFromCode = true
                switchView.isOn = false
            } else {
                print("disconnect here")
                delegate?.fbDisconnetion()
            }
            
        default:
            break
        }
    }
}
