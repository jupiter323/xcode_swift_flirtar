//
//  LikeDislikeTabViewController.swift
//  FlirtARViper
//
//  Created by on 03.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import PKHUD
import XLActionController

class LikeDislikeTabViewController: UIViewController, LikeDislikeTabViewProtocol {

    //MARK: - Outlets
    @IBOutlet weak var profilesKoloda: KolodaView!
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var noMatchLabel: UILabel!
    
    
    
    
    //MARK: - Variables
    fileprivate var users = [ShortUser]()
    fileprivate var controllers = [UIViewController]()
    fileprivate var setMark = true
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilesKoloda.dataSource = self
        profilesKoloda.delegate = self
        noMatchLabel.isHidden = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    //MARK: - LikeDislikeTabViewProtocol
    var presenter: LikeDislikeTabPresenterProtocol?
    
    func showUsers(users: [ShortUser]) {
        
        for eachController in controllers {
            eachController.removeFromParentViewController()
        }
        controllers.removeAll()
        
        
        
        self.users = users
        profilesKoloda.resetCurrentCardIndex()
    }
    
    func appendUsers(newUsers: [ShortUser]) {
        self.users.append(contentsOf: newUsers)
    }
    
    func showActivityIndicator() {
        HUD.show(.labeledProgress(title: ActivityIndicatiorMessage.loading.rawValue, subtitle: nil))
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showError(method: String, errorMessage: String) {
        HUD.show(.labeledError(title: method, subtitle: errorMessage))
        HUD.hide(afterDelay: 3.0)
    }
    
    func showUserBlocked() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let blockAlert = TextNotificationView(frame: UIScreen.main.bounds)
        blockAlert.configureView(withText: TextNotificationViewTexts.userBlocked.rawValue)
        blockAlert.backgroundColor = UIColor(red: 62/255,
                                             green: 67/255,
                                             blue: 79/255,
                                             alpha: 0.7)
        mainView?.addSubview(blockAlert)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            blockAlert.removeFromSuperview()
            self.setMark = false
            self.profilesKoloda.swipe(.left, force: true)
        }
        
    }
    
    func showUserReported() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let blockAlert = TextNotificationView(frame: UIScreen.main.bounds)
        blockAlert.configureView(withText: TextNotificationViewTexts.userReported.rawValue)
        blockAlert.backgroundColor = UIColor(red: 62/255,
                                             green: 67/255,
                                             blue: 79/255,
                                             alpha: 0.7)
        mainView?.addSubview(blockAlert)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            blockAlert.removeFromSuperview()
            self.setMark = false
            self.profilesKoloda.swipe(.left, force: true)
        }
    }
    
    //MARK: - Helpers
    func hideReportNotification() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let lastView = mainView?.subviews.last
        lastView?.removeFromSuperview()
    }
    
    func showReportNotification() {
        let mainView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        let reportNotification = ReportNotificationView(frame: UIScreen.main.bounds)
        reportNotification.configureView()
        reportNotification.delegate = self
        mainView?.addSubview(reportNotification)
        
    }
    
    //MARK: - Actions
    @IBAction func moreOptionsTap(_ sender: Any) {
        
        if users.count == 0 { return }
        
        let currentIndex = profilesKoloda.currentCardIndex
        guard currentIndex >= 0 && currentIndex <= (users.count - 1),
            let userId = users[currentIndex].id else {
            return
        }
        
        let alertController = YoutubeActionController()
        
        alertController.addAction(Action(ActionData(title: "Block User"), style: .default, handler: { action in
            self.presenter?.blockUser(userId: userId)
            
        }))
        alertController.addAction(Action(ActionData(title: "Report"), style: .default, handler: { action in
            self.showReportNotification()
        }))
        alertController.addAction(Action(ActionData(title: "Cancel"), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    

}

//MARK: - ReportNotificationDelegate
extension LikeDislikeTabViewController: ReportNotificationDelegate {
    func sendTap(withText: String) {
        hideReportNotification()
        presenter?.reportUser(withText: withText, andUserId: (users[profilesKoloda.currentCardIndex].id)!)
    }
    
    func cancelReportTap() {
        hideReportNotification()
    }
}

//MARK: - LikeDislikeProfileDelegate
extension LikeDislikeTabViewController: LikeDislikeProfileDelegate {
    
    
    func likeButtonTap(forUser userId: Int) {
        profilesKoloda.swipe(.right)
    }
    
    func dislikeButtonTap(forUser userId: Int) {
        profilesKoloda.swipe(.left)
    }
    
}


//MARK: - KolodaViewDelegate
extension LikeDislikeTabViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        presenter?.viewDidLoad()
    }
    
    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return 0.5
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        switch direction {
        case .right:
            return true
        case .left:
            return true
        default:
            return false
        }
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if setMark {
        
            guard let userId = users[index].id else {
                return
            }
            switch direction {
            case .right:
                presenter?.setMark(forUser: userId, mark: true)
            case .left:
                presenter?.setMark(forUser: userId, mark: false)
            default:
                break
            }
        } else {
            setMark = true
        }
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        
        if index != 0 {
            var controller = controllers.first
            controller?.removeFromParentViewController()
            controller = nil
            if controllers.count != 0 {
                controllers.remove(at: 0)
            }
        }
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("CARD Selected: \(index)")
        presenter?.openProfile(withUser: users[index])
    }
    
    
}

//MARK: - KolodaViewDataSource
extension LikeDislikeTabViewController: KolodaViewDataSource {
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed.default
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        
        if users.count == 0 {
            noMatchLabel.isHidden = false
        } else {
            noMatchLabel.isHidden = true
        }
        
        profilesKoloda.layoutIfNeeded()
        return users.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        profilesKoloda.layoutIfNeeded()
        mainBackView.layoutIfNeeded()
        
        let likeDislikeController = UIStoryboard(name: "LikeDislikeProfile", bundle: nil).instantiateViewController(withIdentifier: "LikeDislikeProfileViewController") as! LikeDislikeProfileViewController
        
        self.addChildViewController(likeDislikeController)
        
        likeDislikeController.delegate = self
        likeDislikeController.user = self.users[index]
        
        controllers.append(likeDislikeController)
        likeDislikeController.view.frame = profilesKoloda.frame
        likeDislikeController.generalCardView.frame = profilesKoloda.frame
        
        return likeDislikeController.generalCardView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("KolodaOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
}

//MARK: - ARProfileViewControllerDelegate
extension LikeDislikeTabViewController: ARProfileViewControllerDelegate {
    func didTapLikeButton(isLike: Bool) {
        if isLike {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.profilesKoloda.swipe(.right)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                self.profilesKoloda.swipe(.left)
            }
        }
    }
}
