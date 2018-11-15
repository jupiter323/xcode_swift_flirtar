//
//  BlockedUsersViewController.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import PKHUD

class BlockedUsersViewController: UIViewController, BlockedUsersViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var blockedUsersTable: UITableView!
    
    //MARK: - Variables
    fileprivate var users = [ShortUser]()
    fileprivate var removedRow: Int?
    
    //MARK - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockedUsersTable.register(UINib(nibName: "BlockedUserCell", bundle: nil), forCellReuseIdentifier: "blockedUserCell")
        blockedUsersTable.tableFooterView = UIView(frame: .zero)
        
        presenter?.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismiss()
    }
    
    //MARK: - BlockedUsersViewProtocol
    var presenter: BlockedUsersPresenterProtocol?
    
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.loading.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func hideUnblockUserAlert() {
        
        
        let lastView = self.view.subviews.last
        lastView?.removeFromSuperview()
    }
    
    func showUnblockUserAlert() {
        
        let unblockAlert = ConfirmNotificationView(frame: UIScreen.main.bounds)
        unblockAlert.configureView(withTitle: "Unblock User?",
                                        subTitle: "You will see each other profiles",
                                        confirmButton: "Yes")
        unblockAlert.delegate = self
        
        self.view.addSubview(unblockAlert)
    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func showBlockedUsers(users: [ShortUser]) {
        self.users = users
        blockedUsersTable.reloadData()
    }
    
    func appendMoreUsers(users: [ShortUser]) {
        self.users.append(contentsOf: users)
        blockedUsersTable.reloadData()
    }
    
    func userUnblocked() {
        if removedRow != nil {
            self.users.remove(at: removedRow!)
            blockedUsersTable.reloadData()
        }
    }
    
    

}

//MARK: - UITableViewDelegate
extension BlockedUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let blockedUserCell = cell as? BlockedUserCell
        blockedUserCell?.unblockButton.tag = indexPath.row
        blockedUserCell?.configureCell(withType: users[indexPath.row])
        blockedUserCell?.delegate = self
        
        
        if users.count != 0 && indexPath.row == (users.count - 1) {
            presenter?.loadMoreUsers()
        }
        
        
        
    }
}

//MARK: - UITableViewDataSource
extension BlockedUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = blockedUsersTable.dequeueReusableCell(withIdentifier: "blockedUserCell")
        return cell!
    }
}

//MARK: - BlockedUserCellDelegate
extension BlockedUsersViewController: BlockedUserCellDelegate {
    func unblockUser(withId: Int, withRow: Int) {
        removedRow = withRow
        presenter?.showUnblockUserAlert(userId: withId)
    }
}

//MARK: - RemoveDialogViewDelegate
extension BlockedUsersViewController: ConfirmNotificationViewDelegate {
    func confirmTap() {
        hideUnblockUserAlert()
        presenter?.unblockUser()
    }
    
    func cancelTap() {
        hideUnblockUserAlert()
        presenter?.unblockCancel()
    }
}
