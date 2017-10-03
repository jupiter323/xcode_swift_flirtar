//
//  ARProfileViewController.swift
//  FlirtARViper
//
//  Created on 12.08.17.
//

import UIKit
import PKHUD
import XLActionController

class ARProfileViewController: UIViewController, ARProfileViewProtocol {

    
    //MARK: - Outlets
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var photosContainer: UIView!
    
    
    
    //MARK: - Variables
    fileprivate var isLiked = false
    fileprivate var interests = [String]()
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        roundedView.layoutIfNeeded()
        roundedView.round(radius: 3.0)
        
        
        interestsCollectionView.register(UINib(nibName: "InterestViewCell", bundle: nil), forCellWithReuseIdentifier: "interestsFullItem")
        
        interestsCollectionView.dataSource = self
        interestsCollectionView.delegate = self
        
    }
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(true)
        
        interestsCollectionView.reloadData()
        
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Actions
    @IBAction func backButtonTap(_ sender: Any) {
        presenter?.dismissMe()
    }
    
    
    @IBAction func likeARTap(_ sender: Any) {
        if !isLiked {
            presenter?.startLike()
            ARProfileDataHelper.shared.changeLikeStatus()
        } else {
            presenter?.startUnlike()
            ARProfileDataHelper.shared.changeLikeStatus()
        }
    }
    
    @IBAction func dislikeARTap(_ sender: Any) {
        presenter?.startDislike()
        ARProfileDataHelper.shared.changeLikeStatus()
    }
    
    @IBAction func moreOptionsTap(_ sender: Any) {
        let alertController = YoutubeActionController()
        
        alertController.addAction(Action(ActionData(title: "Block User"), style: .default, handler: { action in
            
            self.presenter?.blockUser()
            
        }))
        alertController.addAction(Action(ActionData(title: "Report"), style: .default, handler: { action in
            self.showReportNotification()
        }))
        alertController.addAction(Action(ActionData(title: "Cancel"), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
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
    
    
    
    //MARK: - ARProfileViewProtocol
    var presenter: ARProfilePresenterProtocol?
    
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
    
    func showShortProfile(profile: ShortUser) {
        nameLabel.text = profile.firstName ?? "No data"
        ageLabel.text = profile.age ?? "No data"
        introductionLabel.text = profile.shortIntroduction ?? "No data"
        
        guard let isLiked = profile.isLiked else {
            likeButton.setImage(#imageLiteral(resourceName: "likeButtonAR"), for: .normal)
            return
        }

        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "likeButtonARFilled"), for: .normal)
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "likeButtonAR"), for: .normal)
        }
        
        self.isLiked = isLiked
        
        
    }
    
    func likeStatusChanged(newValue: Bool) {
        self.isLiked = newValue
        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "likeButtonARFilled"), for: .normal)
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "likeButtonAR"), for: .normal)
        }
    }
    
    func embedThisModule(module: UIViewController) {
        for view in photosContainer.subviews {
            view.removeFromSuperview()
        }
        
        
        addChildViewController(module)
        module.view.frame = CGRect(x: 0, y: 0, width: photosContainer.frame.size.width, height: photosContainer.frame.size.height)
        photosContainer.addSubview(module.view)
        module.didMove(toParentViewController: self)
    }
    
    func showInterests(interests: [String]) {
        self.interests = interests
        interestsCollectionView.reloadData()
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
        }
    }
    
    

}

//MARK: - ReportNotificationDelegate
extension ARProfileViewController: ReportNotificationDelegate {
    func sendTap(withText: String) {
        hideReportNotification()
        presenter?.reportUser(withText: withText)
    }
    
    func cancelReportTap() {
        hideReportNotification()
    }
}

//MARK: - UICollectionViewDataSource
extension ARProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestsFullItem", for: indexPath)
        return cell
        
    }
    
}

//MARK: - UICollectionViewDelegate
extension ARProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        let interestCell = cell as? InterestViewCell
        guard interestCell != nil else { return }
        interestCell!.configureCell(withInterest: interests[indexPath.row],
                                     maxFontSize: 13.0,
                                     fontColor: UIColor(red: 62/255,
                                                        green: 67/255,
                                                        blue: 79/255,
                                                        alpha: 1.0),
                                     fontName: "VarelaRound")
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ARProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //3 columns
        let cellWidth = collectionView.bounds.width / 3.0
        //1 row and 33% of next row
        let cellHeight = collectionView.bounds.height - (collectionView.bounds.height / 3)
        let size = CGSize(width: cellWidth, height: cellHeight)
        return size
    }
    
    //No spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
    }
}
