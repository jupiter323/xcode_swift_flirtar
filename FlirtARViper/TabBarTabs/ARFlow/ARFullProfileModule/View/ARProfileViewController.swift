//
//  ARProfileViewController.swift
//  FlirtARViper
//
//  Created on 12.08.17.
//

import UIKit
import PKHUD
import XLActionController

protocol ARProfileViewControllerDelegate: class {
    func didTapLikeButton(isLike: Bool)
}

class ARProfileViewController: UIViewController, ARProfileViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    @IBOutlet weak var introductionTextView: UITextView!
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var photosContainer: UIView!
    
    @IBOutlet weak var roundedViewInset: UIView!
    
    @IBOutlet weak var instagramPhotosContainer: UIView!
    
    @IBOutlet weak var infoBlockView: UIView!
    
    @IBOutlet weak var nameAgeView: UIView!
    @IBOutlet weak var interestsView: UIView!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    //MARK: - Constraints
    @IBOutlet var instagramPhotosHeight: NSLayoutConstraint!

    @IBOutlet var interestsHeight: NSLayoutConstraint!
    @IBOutlet var interestsViewRight: NSLayoutConstraint!
    
    @IBOutlet var introductionViewInitialHeight: NSLayoutConstraint!
    @IBOutlet var introductionViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    //MARK: Data
    fileprivate var isLiked = false
    fileprivate var interests = [String]()
    fileprivate var introductionIsFullSize: Bool = false
    fileprivate var profile: ShortUser?
    
    //MARK: Constraints
    fileprivate var collectionViewInitialHeight: CGFloat = 0.0
    fileprivate var introductionInitialHeight: CGFloat = 0.0
    
    //MARK: Visual
    fileprivate var introductionTextFont = UIFont(name: "VarelaRound", size: 13.0) ??
                                            UIFont.systemFont(ofSize: 13.0)
    fileprivate var introductionTextColor = UIColor(red: 166/255,
                                                    green: 172/255,
                                                    blue: 185/255,
                                                    alpha: 1.0)
    fileprivate var introductionMoreTextColor = UIColor(red: 251/255,
                                                        green: 95/255,
                                                        blue: 119/255,
                                                        alpha: 1.0)
    fileprivate var introductionMoreText = "Full Desc."
    
    
    weak var delegate: ARProfileViewControllerDelegate?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView()

        roundedView.layoutIfNeeded()
        roundedView.round(radius: 3.0)
        
        
        interestsCollectionView.register(UINib(nibName: "InterestViewCell", bundle: nil), forCellWithReuseIdentifier: "interestsFullItem")
        
        inititalizeLayouts()
        
        presenter?.viewDidLoad()
        
    }
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController as? TabBarViewController)?.animationTabBarHidden(true)
        
        roundedViewInset.layoutIfNeeded()
        let distance = roundedViewInset.bounds.height + 20.0
        
        presenter?.viewWillAppear(distance: distance)
        
        initializeInterestsLayouts()
        shortIntroductionLayouts()
        
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
    
    @IBAction func moreInfoTap(_ sender: Any) {
        
        //show all interests
        fullInterestsLayouts()
        
        //add read more label if need
        if introductionIsFullSize {
            //initial height
        } else {
            //height is active
            if !introductionIsFullSize {
                addReadMoreTextToTextView()
                
            }
            
        }
        

        
    }
    
    
    //MARK: - Helpers
    @objc private func introductionTapped(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            fullIntroductionLayouts()
        }
    }
    
    
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
    
    func configureTextView() {
        introductionTextView.font = introductionTextFont
        introductionTextView.textColor = introductionTextColor
        introductionTextView.textContainerInset = UIEdgeInsets.zero
        introductionTextView.textContainer.lineFragmentPadding = 0
    }
    
    func addReadMoreTextToTextView() {
        introductionTextView.addReadMoreText(with: " ",
                                             moreText: introductionMoreText,
                                             moreTextFont: introductionTextFont,
                                             moreTextColor: introductionMoreTextColor)
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
        self.profile = profile
        nameLabel.text = profile.firstName ?? "No data"
        ageLabel.text = profile.age ?? "No data"
        
        introductionTextView.text = profile.shortIntroduction ?? "No data"
        
        configureTextView()
        addReadMoreTextToTextView()
        
        guard let isLiked = profile.isLiked else {
            likeButton.setImage(#imageLiteral(resourceName: "likeBigInact"), for: .normal)
            return
        }

        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "likeBigAct"), for: .normal)
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "likeBigInact"), for: .normal)
        }
        
        self.isLiked = isLiked
        
        
    }
    
    func likeStatusChanged(newValue: Bool) {
        self.isLiked = newValue
        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "likeButtonNewAc"), for: .normal)
            delegate?.didTapLikeButton(isLike: true)
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "likeBigInact"), for: .normal)
            delegate?.didTapLikeButton(isLike: false)
        }
        
        presenter?.dismissMe()
        
    }
    
    func embedThisModule(module: UIViewController,
                         type: PhotosModuleType) {
        
        switch type {
        case .apiPhotos:
            for view in photosContainer.subviews {
                view.removeFromSuperview()
            }
            
            
            addChildViewController(module)
            module.view.frame = CGRect(x: 0, y: 0, width: photosContainer.frame.size.width, height: photosContainer.frame.size.height)
            photosContainer.addSubview(module.view)
            module.didMove(toParentViewController: self)
        case .instagramPhotos:
            for view in instagramPhotosContainer.subviews {
                view.removeFromSuperview()
            }
            
            addChildViewController(module)
            module.view.frame = CGRect(x: 0, y: 0, width: instagramPhotosContainer.frame.size.width, height: instagramPhotosContainer.frame.size.height)
            instagramPhotosContainer.addSubview(module.view)
            module.didMove(toParentViewController: self)
            
            if let instaPhotos = module as? InstagramPhotosViewController {
                instaPhotos.delegate = self
            }
        }
        
        
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
    
    //MARK: - Layouts
    func inititalizeLayouts() {
        
        interestsCollectionView.layoutIfNeeded()
        collectionViewInitialHeight = 20.0
        
        introductionTextView.layoutIfNeeded()
        introductionInitialHeight = introductionTextView.bounds.height
        
        introductionTextView.isUserInteractionEnabled = true
        introductionTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(introductionTapped(recognizer:))))
        
    }
    
    func initializeInterestsLayouts() {
        if interests.count > 3 {
            moreInfoButton.isHidden = false
            interestsViewRight.constant = 70.0
            interestsCollectionView.collectionViewLayout.invalidateLayout()
        } else {
            moreInfoButton.isHidden = true
            interestsViewRight.constant = 20.0
            interestsCollectionView.collectionViewLayout.invalidateLayout()
        }
        
        shortInterestsLayouts()
    }
    
    func shortInterestsLayouts() {
        interestsHeight.constant = 20.0
        interestsHeight.isActive = true
    }
    
    func fullInterestsLayouts() {
        moreInfoButton.isHidden = true
        interestsViewRight.constant = 15.0
        interestsView.layoutIfNeeded()
        
        interestsCollectionView.collectionViewLayout.invalidateLayout()
        
        interestsCollectionView.layoutIfNeeded()
        let contentHeight = interestsCollectionView.contentSize.height
        interestsHeight.constant = contentHeight
        interestsHeight.isActive = true
    }
    
    func shortIntroductionLayouts() {
        
        roundedView.layoutIfNeeded()
        introductionTextView.layoutIfNeeded()
        
        introductionTextView.text = profile?.shortIntroduction ?? "No data"
        introductionTextView.layoutIfNeeded()
        
        configureTextView()
        
        addReadMoreTextToTextView()
        
        introductionViewInitialHeight.isActive = true
        introductionViewHeight.constant = introductionInitialHeight
        introductionViewHeight.isActive = false
        
        introductionIsFullSize = false
        
        
        
        
    }
    
    func fullIntroductionLayouts() {
        
        //
        introductionTextView.text = profile?.shortIntroduction ?? "No data"
        
        let introWidth = introductionTextView.bounds.width
        let font = introductionTextFont
        let estimatedTextHeight = introductionTextView.text!.estimateFrameForText(font: font,
                                                                                  width: introWidth).height + 4
        
        configureTextView()
        
        if estimatedTextHeight > introductionInitialHeight {
            introductionViewInitialHeight.isActive = false
            introductionViewHeight.constant = estimatedTextHeight
            introductionViewHeight.isActive = true
        }
        
        introductionIsFullSize = true
        
        
    }
    
    

}

//MARK: - InstagramPhotosViewControllerDelegate
extension ARProfileViewController: InstagramPhotosViewControllerDelegate {
    func photosUpdated(moduleHeight: CGFloat,
                       photosCount: Int) {
        instagramPhotosHeight.constant = moduleHeight
        
        if photosCount != 0 {
            
            let introWidth = introductionTextView.bounds.width
            let font = introductionTextFont
            let estimatedTextHeight = introductionTextView.text!.estimateFrameForText(font: font,
                                                                                      width: introWidth).height + 4
            
            if estimatedTextHeight < introductionInitialHeight {
                introductionViewInitialHeight.isActive = false
                introductionViewHeight.constant = estimatedTextHeight
                introductionViewHeight.isActive = true
            }
            
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
        //1 row
        let cellHeight = collectionViewInitialHeight
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
