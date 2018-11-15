//
//  NotificationCell.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func showOnMapStatusChanged(isEnabled: Bool)
    func allowUserLocationStatusChanged(isEnabled: Bool)
    func notificationStatusChanged(isEnabled: Bool, notificationType: CellConfiguration)
}

//all methods optional
extension SwitchCellDelegate {
    func showOnMapStatusChanged(isEnabled: Bool) {}
    func allowUserLocationStatusChanged(isEnabled: Bool) {}
    func notificationStatusChanged(isEnabled: Bool, notificationType: CellConfiguration) {}
}

class SwitchCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var switchView: SwitchView!
    
    //MARK: - Variables
    fileprivate var cellType: CellConfiguration?
    weak var delegate: SwitchCellDelegate?
    
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
        case .Nofitication(.like):
            switchView.title = "You've got a Like"
        case .Nofitication(.message):
            switchView.title = "You've got a New Message"
        case .Nofitication(.newUserInArea):
            switchView.title = "New User in your area"
        case .Account(.showOnMapSwitch):
            switchView.title = "Show me on the Map for other users"
        case .Account(.userLocationSwitch):
            switchView.title = "Allow manual position on the Map"
        default:
            break
        }
        
        cellType = type
        switchView.isOn = state
    }
    
}

extension SwitchCell: SwitchViewDelegate {
    func valueChanged(switchView: SwitchView) {
        guard cellType != nil else {
            return
        }
        
        switch cellType! {
        case .Account(.showOnMapSwitch):
            delegate?.showOnMapStatusChanged(isEnabled: switchView.isOn)
        case .Account(.userLocationSwitch):
            delegate?.allowUserLocationStatusChanged(isEnabled: switchView.isOn)
        case .Nofitication(.like):
            delegate?.notificationStatusChanged(isEnabled: switchView.isOn, notificationType: .Nofitication(.like))
        case .Nofitication(.message):
            delegate?.notificationStatusChanged(isEnabled: switchView.isOn, notificationType: .Nofitication(.message))
        case .Nofitication(.newUserInArea):
            delegate?.notificationStatusChanged(isEnabled: switchView.isOn, notificationType: .Nofitication(.newUserInArea))
        default:
            break
        }
        
    }
}
