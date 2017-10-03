//
//  NotificationsTabViewController.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD

typealias NotificationTuple = (type: CellConfiguration, status: Bool)

class NotificationsInfoViewController: UIViewController, NotificationsInfoViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var notificationsTable: UITableView!
    
    //MARK: - Variables
    fileprivate var notifications: [CellConfiguration] = [.Nofitication(.like), .Nofitication(.message), .Nofitication(.newUserInArea)]
    fileprivate var notificationsTuples: [NotificationTuple] = [NotificationTuple]()
    fileprivate var cellIdentifier = "switchCell"
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTable.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        notificationsTable.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    //MARK: - NotificationsTabViewProtocol
    var presenter: NotificationsInfoPresenterProtocol?
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.waiting.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func notificationChanged() {
        HUD.show(.labeledSuccess(title: SuccessMessage.saved.rawValue, subtitle: nil))
        HUD.hide(afterDelay: 3.0)
    }
    
    func notificationChangeError(method: String, errorMessage: String, type: CellConfiguration) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
        
        //change switchValue from code
        let notificationCellRow = notifications.index(of: type)
        if notificationCellRow != nil {
            let indexPath = IndexPath(row: notificationCellRow!, section: 0)
            let cell = notificationsTable.cellForRow(at: indexPath) as? SwitchCell
            cell?.switchView.isOn = !(cell?.switchView.isOn)!
        }
    }
    
    func showNotifications(notifications: [NotificationTuple]) {
        self.notificationsTuples = notifications
        notificationsTable.reloadData()
    }
    
    
}


//MARK: - UITableViewDataSource
extension NotificationsInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SwitchCell
        guard cell != nil else {
            return UITableViewCell()
        }
        
        let index = notificationsTuples.index { (searchTuple) -> Bool in
            if searchTuple.type == notifications[indexPath.row] {
                return true
            } else {
                return false
            }
        }
        
        if index != nil {
            cell?.configureCell(withType: notifications[indexPath.row], state: notificationsTuples[index!].status)
        } else {
            cell?.configureCell(withType: notifications[indexPath.row], state: false)
        }
        
        cell?.delegate = self
        
        return cell!
    }
}

//MARK: - UITableViewDelegate
extension NotificationsInfoViewController: UITableViewDelegate {
    
}

//MARK: - SwitchCellDelegate
extension NotificationsInfoViewController: SwitchCellDelegate {
    func notificationStatusChanged(isEnabled: Bool, notificationType: CellConfiguration) {
        presenter?.saveNotification(isEnabled: isEnabled, type: notificationType)
    }
    
    func allowUserLocationStatusChanged(isEnabled: Bool) {
        return
    }
    
    func showOnMapStatusChanged(isEnabled: Bool) {
        return
    }
}
