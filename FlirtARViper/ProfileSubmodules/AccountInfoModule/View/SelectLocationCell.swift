//
//  SelectLocationCell.swift
//  FlirtARViper
//
//  Created by on 04.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import CoreLocation

class SelectLocationCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var switchSubtitleView: SwitchSubtitleView!
    
    
    //MARK: - Variables
    fileprivate var cellType: CellConfiguration?
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchSubtitleView.delegate = self
        
    }
    
    func configureCell(withType type: CellConfiguration, state: Bool) {
        switch type {
        case .Account(.userLocationSwitch):
            switchSubtitleView.title = "Allow manual position on the Map"
        default:
            break
        }
        
        cellType = type
        switchSubtitleView.isOn = state
    }
    
    func configureCell(withType type: CellConfiguration, state: Bool, location: CLLocation) {
        
        switch type {
        case .Account(.userLocationSwitch):
            self.configureCell(withType: type, state: state)
            
            CLGeocoder().getAddressForLocation(location: location, completionHandler: { (address) in
                guard let addressString = address else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.switchSubtitleView.subTitle = addressString
                    self.switchSubtitleView.layoutIfNeeded()
                    self.switchSubtitleView.layoutSubviews()
                }
                
            })
            
            
        default:
            break
        }
        
    }
    
    
    
}

extension SelectLocationCell: SwitchSubtitleViewDelegate {
    func valueChanged(switchView: SwitchSubtitleView) {
        guard cellType != nil else {
            return
        }
        
        switch cellType! {
        case .Account(.userLocationSwitch):
            delegate?.allowUserLocationStatusChanged(isEnabled: switchView.isOn)
        default:
            break
        }
    }
}
