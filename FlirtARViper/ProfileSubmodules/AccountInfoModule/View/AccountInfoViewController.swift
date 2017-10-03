//
//  AccountInfoViewController.swift
//  FlirtARViper
//
//  Created on 07.08.17.
//

import UIKit
import CoreLocation
import PKHUD


enum CellConfiguration {
    case Nofitication(NotificationType)
    case Account(AccountCellType)
    
    enum NotificationType {
        case like
        case message
        case newUserInArea
        case all
    }
    
    enum AccountCellType {
        case blockUsers
        case showOnMapSwitch
        case userLocationSwitch
        case fbSwitch
        case logout
    }
}


extension CellConfiguration: Equatable {
    
    static func ==(lhs: CellConfiguration, rhs: CellConfiguration) -> Bool {
        
        switch (lhs, rhs) {
        case (.Account(let a1), .Account(let a2)):
            return a1 == a2
        case (.Nofitication(let n1), .Nofitication(let n2)):
            return n1 == n2
        default:
            return false
        }
    }

    
}

class AccountInfoViewController: UIViewController, AccountInfoViewProtocol {

    //MARK: - Outlets
    @IBOutlet var accountTable: UITableView!
    
    //MARK: - Private
    fileprivate var accountCells: [CellConfiguration] = [.Account(.blockUsers) ,.Account(.showOnMapSwitch), .Account(.userLocationSwitch), .Account(.fbSwitch), .Account(.logout)]
    fileprivate var currentUser = User()
    fileprivate var notificationsEnabled = false
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        //register cell here
        accountTable.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        accountTable.register(UINib(nibName: "ImagedSwitchCell", bundle: nil), forCellReuseIdentifier: "imagedSwitchCell")
        accountTable.register(UINib(nibName: "TitledCell", bundle: nil), forCellReuseIdentifier: "titledCell")
        accountTable.register(UINib(nibName: "SelectLocationCell", bundle: nil), forCellReuseIdentifier: "selectLocationCell")
        accountTable.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    //MARK: - AccountInfoViewProtocol
    var presenter: AccountInfoPresenterProtocol?
    
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.waiting.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showSuccessMessage(messageType: SuccessMessage) {
        HUD.show(.labeledSuccess(title: messageType.rawValue, subtitle: nil))
        HUD.hide(afterDelay: 3.0)
    }
    
    
    func showFBDisconnectSuccess(messageType: SuccessMessage) {
        HUD.show(.labeledSuccess(title: messageType.rawValue, subtitle: nil))
        HUD.hide(afterDelay: 3.0)
        
        let fbCellRow = accountCells.index(of: .Account(.fbSwitch))
        if fbCellRow != nil {
            let indexPath = IndexPath(row: fbCellRow!, section: 0)
            let cell = accountTable.cellForRow(at: indexPath) as? ImagedSwitchCell
            cell?.switchView.isUserInteractionEnabled = false
        }
    }
    
    
    func showFBDisconnectError(method: String, errorMessage: String) {
        
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
        
        let fbCellRow = accountCells.index(of: .Account(.fbSwitch))
        if fbCellRow != nil {
            let indexPath = IndexPath(row: fbCellRow!, section: 0)
            let cell = accountTable.cellForRow(at: indexPath) as? ImagedSwitchCell
            cell?.switchView.isOn = !(cell?.switchView.isOn)!
        }
    }
    
    
    
    func showLogoutSuccess() {
        let delay = 3.0
        
        HUD.show(.labeledSuccess(title: SuccessMessage.logouted.rawValue, subtitle: nil))
        HUD.hide(afterDelay: delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.presenter?.showSplash()
        }

    }
    
    
    func locationChangeError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
        ignoreLocationChange()
    }
    
    
    func showRequestError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    
    
    func fillDataWithUser(user: User) {
        currentUser = user
        accountTable.reloadData()
    }
    
    func locationSelectCancelled() {
        ignoreLocationChange()
    }
    
    func showNewLocation(address: String) {
        let locationCellRow = accountCells.index(of: .Account(.userLocationSwitch))
        if locationCellRow != nil {
            let indexPath = IndexPath(row: locationCellRow!, section: 0)
            let cell = accountTable.cellForRow(at: indexPath) as? SelectLocationCell
            cell?.switchSubtitleView.subTitle = address
            cell?.switchSubtitleView.layoutIfNeeded()
            cell?.switchSubtitleView.layoutSubviews()
        }

    }
    
    
    //MARK: - Helpers
    fileprivate func ignoreLocationChange() {
        //change switchValue from code
        let locationCellRow = accountCells.index(of: .Account(.userLocationSwitch))
        if locationCellRow != nil {
            let indexPath = IndexPath(row: locationCellRow!, section: 0)
            let cell = accountTable.cellForRow(at: indexPath) as? SelectLocationCell
            cell?.switchSubtitleView.isOn = !(cell?.switchSubtitleView.isOn)!
            cell?.switchSubtitleView.subTitle = ""
        }
    }
    
    

}


//MARK: - UITableViewDataSource
extension AccountInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        switch accountCells[indexPath.row] {
            
        case .Account(.blockUsers):
            cell = tableView.dequeueReusableCell(withIdentifier: "titledCell")
        case .Account(.showOnMapSwitch):
            cell = tableView.dequeueReusableCell(withIdentifier: "switchCell")
        case .Account(.userLocationSwitch):
            cell = tableView.dequeueReusableCell(withIdentifier: "selectLocationCell")
        case .Account(.fbSwitch):
            cell = tableView.dequeueReusableCell(withIdentifier:  "imagedSwitchCell")
        case .Account(.logout):
            cell = tableView.dequeueReusableCell(withIdentifier: "titledCell")
        default:
            return UITableViewCell()
        }
        
        guard cell != nil else {
            return UITableViewCell()
        }
        return cell!
    }
}

//MARK: - UITableViewDelegate
extension AccountInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch accountCells[indexPath.row] {
            
        case .Account(.blockUsers):
            let titledCell = cell as? TitledCell
            titledCell?.configureCell(withType: .Account(.blockUsers))
            titledCell?.delegate = self
        case .Account(.showOnMapSwitch):
            let switchCell = cell as? SwitchCell
            switchCell?.configureCell(withType: .Account(.showOnMapSwitch), state: currentUser.showOnMap ?? false)
            switchCell?.delegate = self
        case .Account(.userLocationSwitch):
            let selectLocationCell = cell as? SelectLocationCell
            if let location = ProfileService.userLocation {
                selectLocationCell?.configureCell(withType: .Account(.userLocationSwitch), state: true, location: location)
            } else {
                selectLocationCell?.configureCell(withType: .Account(.userLocationSwitch), state: false)
            }
            selectLocationCell?.delegate = self
        case .Account(.fbSwitch):
            let imagedSwitchCell = cell as? ImagedSwitchCell
            imagedSwitchCell?.configureCell(withType: .Account(.fbSwitch), state: currentUser.isFacebook ?? false)
            imagedSwitchCell?.delegate = self
        case .Account(.logout):
            let titledCell = cell as? TitledCell
            titledCell?.configureCell(withType: .Account(.logout))
            titledCell?.delegate = self
        default:
            break
        }
    }
}

//MARK: - SwitchCellDelegate
extension AccountInfoViewController: SwitchCellDelegate {
    func notificationStatusChanged(isEnabled: Bool, notificationType: CellConfiguration) {
        return
    }

    func showOnMapStatusChanged(isEnabled: Bool) {
        presenter?.saveShowOnMap(isEnabled: isEnabled)
    }
    
    func allowUserLocationStatusChanged(isEnabled: Bool) {
        if !isEnabled {
            showNewLocation(address: "")
        }
        presenter?.allowUserLocationCanged(isEnabled: isEnabled)
    }
}

//MARK: - TitledCellDelegate
extension AccountInfoViewController: TitledCellDelegate {
    func logoutTap() {
        presenter?.logout()
    }
    
    func blockedUsersTap() {
        presenter?.showBlockedUsers()
    }
}

//MARK: - ImagedSwitchCellDelegate
extension AccountInfoViewController: ImagedSwitchCellDelegate {
    func fbDisconnetion() {
        presenter?.facebookConnectionDisable()
    }
}
