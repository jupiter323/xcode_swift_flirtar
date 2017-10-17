//
//  MessagesMainViewController.swift
//  FlirtARViper
//
//  Created by  on 05.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import PKHUD
import SWTableViewCell

class MessagesMainTabViewController: UIViewController, MessagesMainTabViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var likesModule: UIView!
    
    //MARK: - Constraints
    @IBOutlet weak var likesBlockHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    fileprivate var dialogs = [Dialog]()
    fileprivate let refreshControl = UIRefreshControl()
    
    fileprivate var likesSubmodule: MessagesLikesViewController?
    
    fileprivate var removedRow: Int?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likesBlockHeight.constant = UIScreen.main.bounds.width / 4.0
        likesModule.layoutIfNeeded()
        
        
        presenter?.viewDidLoad()
        
        messagesTable.register(UINib(nibName: "DialogCell", bundle: nil), forCellReuseIdentifier: "dialogCell")
        messagesTable.tableFooterView = UIView(frame: .zero)
        
        
        refreshControl.addTarget(self, action: #selector(refreshDialogs(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            messagesTable.refreshControl = refreshControl
        } else {
            messagesTable.backgroundView = refreshControl
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshDialogs(_ refreshControl: UIRefreshControl) {
        presenter?.reloadDialogs()
    }
    
    //MARK: - MessagesMainTabViewProtocol
    var presenter: MessagesMainTabPresenterProtocol?
    
    func showActivityIndicator(withType: ActivityIndicatiorMessage) {
        HUD.show(.labeledProgress(title: withType.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
        messagesTable.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showMessages(dialogs: [Dialog]) {
        self.dialogs = dialogs
        messagesTable.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    func appendMoreMessages(dialogs: [Dialog]) {
//        print(">>>APPENDING")
        self.dialogs.append(contentsOf: dialogs)
        messagesTable.reloadData()
    }
    
    func newMessage(message: Message, forRoom room: Int) {
//        print(message)
        
        var foundedDialog: Dialog?
        
        for i in 0..<self.dialogs.count {
            if self.dialogs[i].id == room {
                foundedDialog = self.dialogs[i]
                foundedDialog?.message = message
                if let isRead = message.isRead {
                    if !isRead && foundedDialog?.unreadCount != nil {
                        let currentCount = (foundedDialog?.unreadCount)!
                        foundedDialog?.unreadCount = currentCount + 1
                    }
                }
                
                self.dialogs.remove(at: i)
                break
            }
        }
        
        if foundedDialog != nil {
            self.dialogs.insert(foundedDialog!, at: 0)
            self.messagesTable.reloadData()
        } else {
            presenter?.reloadDialogs()
        }
        
        
    }
    
    
    func dialogRemoved() {
        if removedRow != nil {
            dialogs.remove(at: removedRow!)
            likesSubmodule?.reloadData()
        }
        messagesTable.reloadData()
    }
    
    func hideRemoveDialogAlert() {
        messagesTable.reloadData()
        
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let lastView = mainView?.subviews.last
        lastView?.removeFromSuperview()
    }
    
    func showRemoveDialogAlert() {
        
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let removeDialogAlert = ConfirmNotificationView(frame: UIScreen.main.bounds)
        removeDialogAlert.configureView(withTitle: "Delete?",
                                        subTitle: "The Message Chain will be deleted",
                                        confirmButton: "Delete")
        removeDialogAlert.delegate = self
        mainView?.addSubview(removeDialogAlert)
    }
    
    func embedThisModule(module: UIViewController) {
        for view in likesModule.subviews {
            view.removeFromSuperview()
        }
        
        addChildViewController(module)
        module.view.frame = CGRect(x: 0, y: 0, width: likesModule.frame.size.width, height: likesModule.frame.size.height)
        likesModule.addSubview(module.view)
        module.didMove(toParentViewController: self)
        
        if module is MessagesLikesViewController {
            (module as! MessagesLikesViewController).delegate = self
            likesSubmodule = module as? MessagesLikesViewController
        }
    }
    
    

}

//MARK: - MessagesLikesViewControllerDelegate
extension MessagesMainTabViewController: MessagesLikesViewControllerDelegate {
    func dialogsListNeedUpdate() {
        presenter?.reloadDialogs()
    }
}

//MARK: - RemoveDialogViewDelegate
extension MessagesMainTabViewController: ConfirmNotificationViewDelegate {
    func confirmTap() {
        hideRemoveDialogAlert()
        presenter?.removeDialog()
    }
    
    func cancelTap() {
        hideRemoveDialogAlert()
        presenter?.removeCancel()
    }
}

//MARK: - UITableViewDataSource
extension MessagesMainTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogCell") as? DialogCell
        guard cell != nil else {
            return UITableViewCell()
        }
        
        let rightButtons = NSMutableArray()
        rightButtons.sw_addUtilityButton(with: UIColor(red: 166/255,
                                                       green: 172/255,
                                                       blue: 185/255,
                                                       alpha: 1.0), icon: #imageLiteral(resourceName: "deleteIcon"))
        cell?.delegate = self
        cell?.rightUtilityButtons = rightButtons as! [Any]
        
        cell?.configureCell(withDialog: dialogs[indexPath.row])
        return cell!
        
    }
    
}

//MARK: - UITableViewDelegate
extension MessagesMainTabViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.openChat(selectedChat: dialogs[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //load more messages
        if dialogs.count != 0 && indexPath.row == (dialogs.count - 1) {
            presenter?.loadMoreDialogs()
        }
    }
}

//MARK: - SWTableViewCellDelegate
extension MessagesMainTabViewController: SWTableViewCellDelegate {
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        switch index {
        case 0:
            let indexPath = self.messagesTable.indexPath(for: cell)
            if let row = indexPath?.row {
                if row < dialogs.count && row >= 0 {
                    removedRow = row
                    presenter?.showRemoveDialogAlert(chat: dialogs[row])
                }
            }
            
        default:
            break
        }
    }
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, scrollingTo state: SWCellState) {
        switch state {
        case .cellStateCenter:
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                cell.backgroundColor = UIColor.white
            })
            
        case .cellStateRight:
            
            UIView.animate(withDuration: 0.3,
                           animations: { 
                cell.backgroundColor = UIColor(red: 251/255,
                                               green: 251/255,
                                               blue: 251/255,
                                               alpha: 1.0)
            })
            
        case .cellStateLeft:
            break
        }
    }
}
