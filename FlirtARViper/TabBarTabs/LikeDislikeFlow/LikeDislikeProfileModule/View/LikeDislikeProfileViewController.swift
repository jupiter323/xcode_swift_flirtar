//
//  LikeDislikeProfileViewController.swift
//  FlirtARViper
//
//  Created by on 04.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol LikeDislikeProfileDelegate: class {
    func likeButtonTap(forUser userId: Int)
    func dislikeButtonTap(forUser userId: Int)
}

class KolodaMainView: UIView {
    
}

class KolodaButtonsView: UIView {
    
}

class LikeDislikeProfileViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var embedVerticalPhotos: UIView!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet var interestsCollection: [InterestItemView]!
    
    
    
    @IBOutlet var generalCardView: KolodaMainView!
    
    @IBOutlet weak var buttonsView: KolodaButtonsView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    
    //MARK: - Variables
    var user: ShortUser?
    
    weak var delegate: LikeDislikeProfileDelegate?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        infoView.layoutIfNeeded()
        infoView.layer.cornerRadius = 3.0
        
        
        embedVerticalPhotos.layoutIfNeeded()
        embedVerticalPhotos.layoutSubviews()
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = user else {
            return
        }
        
        firstnameLabel.text = user.firstName ?? "No data"
        ageLabel.text = user.age ?? "No data"
        
        let module = UserPhotosWireframe
            .configurePhotosController(withPhotos: user.photos,
                                       orientation: .vertical,
                                       containerType: nil,
                                       distance: nil)
        
        for view in embedVerticalPhotos.subviews {
            view.removeFromSuperview()
        }
        
        addChildViewController(module)
        module.view.frame = CGRect(x: 0, y: 0, width: embedVerticalPhotos.frame.size.width, height: embedVerticalPhotos.frame.size.height)
        embedVerticalPhotos.addSubview(module.view)
        module.didMove(toParentViewController: self)
        
        guard let interests = user.interests else {
            return
        }
        
        let interestsArrayByComma = interests.components(separatedBy: ",")
        let interestsArrayBySpace = interests.components(separatedBy: " ")
        
        var newInterests = [String]()
        
        if interestsArrayByComma.count >= interestsArrayBySpace.count {
            newInterests = Array(interestsArrayByComma.prefix(3)).filter{$0 != ""}
        } else {
            newInterests = Array(interestsArrayBySpace.prefix(3)).filter{$0 != ""}
        }
        
        for i in 0..<newInterests.count {
            let interestView = interestsCollection[i]
            interestView.isHidden = false
            
            var title = newInterests[i]
            if i == interestsCollection.count - 1 && interestsArrayByComma.count > 3 {
                title += "..."
            }
            
            interestView.title = title
            interestView.itemTextColor = UIColor(red: 62/255,
                                                 green: 67/255,
                                                 blue: 79/255,
                                                 alpha: 1.0)
            interestView.itemTextFont = UIFont(name: "VarelaRound", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        }
        
        if newInterests.count < 3 {
            for j in newInterests.count..<interestsCollection.count {
                let interestView = interestsCollection[j]
                interestView.isHidden = true
            }
        }
        
    }
    
    
    //MARK: - Actions
    @IBAction func dislikeButtonTap(_ sender: Any) {
        guard let userId = user?.id else {
            return
        }
        delegate?.dislikeButtonTap(forUser: userId)
    }
    
    @IBAction func likeButtonTap(_ sender: Any) {
        guard let userId = user?.id else {
            return
        }
        delegate?.likeButtonTap(forUser: userId)
    }
    
    
    

}

