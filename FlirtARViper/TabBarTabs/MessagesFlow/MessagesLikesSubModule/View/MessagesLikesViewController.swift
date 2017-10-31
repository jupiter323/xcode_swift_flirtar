//
//  MessagesLikesViewController.swift
//  FlirtARViper
//
//  Created by on 11.10.2017.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol MessagesLikesViewControllerDelegate: class {
    func dialogsListNeedUpdate()
}

class MessagesLikesViewController: UIViewController, MessagesLikesViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var likesCollectionView: UICollectionView!
    @IBOutlet weak var noLikesLabel: UILabel!
    
    //MARK: - Variables
    fileprivate var likes = [ShortUser]()
    
    weak var delegate: MessagesLikesViewControllerDelegate?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likesCollectionView.register(UINib(nibName: "MessagesLikesViewCell", bundle: nil), forCellWithReuseIdentifier: "messagesLikesCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    //MARK: - Helpers
    func reloadData() {
        presenter?.reloadData()
    }
    
    func checkDataIsEmpty() {
        //empty likes
        if likes.count == 0 {
            noLikesLabel.isHidden = false
            likesCollectionView.isHidden = true
        } else {
            //likes not empty
            noLikesLabel.isHidden = true
            likesCollectionView.isHidden = false
        }
    }
    
    //MARK: - MessagesLikesViewProtocol
    var presenter: MessagesLikesPresenterProtocol?
    
    func showLikes(likes: [ShortUser]) {
        self.likes = likes
        likesCollectionView.reloadData()
        checkDataIsEmpty()
    }
    
    func appendMoreLikes(likes: [ShortUser]) {
        self.likes.append(contentsOf: likes)
        likesCollectionView.reloadData()
        checkDataIsEmpty()
    }

}

//MARK: - ARProfileViewControllerDelegate
extension MessagesLikesViewController: ARProfileViewControllerDelegate {
    func didTapLikeButton(isLike: Bool) {
        delegate?.dialogsListNeedUpdate()
        reloadData()
    }
}

//MARK: - UICollectionViewDelegate
extension MessagesLikesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let likeCell = cell as? MessagesLikesViewCell
        likeCell?.configureCell(withLike: likes[indexPath.row])
        
        if likes.count != 0 && indexPath.row == (likes.count - 1) {
            presenter?.loadMoreLikes()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profile = likes[indexPath.row]
        presenter?.openProfile(withUser: profile)
    }
}

//MARK: - UICollectionViewDataSource
extension MessagesLikesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messagesLikesCell", for: indexPath) as? MessagesLikesViewCell
        guard cell != nil else {
            return UICollectionViewCell()
        }
        return cell!
    }
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MessagesLikesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width / 4.0
        let cellHeight = UIScreen.main.bounds.width / 4.0
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










