//
//  ARProfileDataHelper.swift
//  FlirtARViper
//
//  Created by on 07.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum ARButtonsType {
    case nextButton
    case previousButton
}

protocol ARProfileDataHelperDelegate {
    func dataUpdated(user: ShortUser)
    func changeButtonVisibility(buttonType: ARButtonsType, isHidden: Bool)
}

class ARProfileDataHelper {
    
    //MARK: - Init
    static var shared = ARProfileDataHelper()
    
    func configureWithMarkers(markers: [Marker]?) {
        
        //restore initial values
        self.selectedUser = nil
        self.isLiked = false
        self.selectedIndex = 0
        self.isInitial = true
        
        //set new values
        self.markers = markers
    }
    
    func tryToUpdate(markers: [Marker]) {
        if isInitial {
            selectedIndex = 0
            loadData()
            isInitial = false
        } else {
            updateData(markers: markers)
        }
    }
    
    //MARK: - Delegate
    var delegate: ARProfileDataHelperDelegate?
    
    //MARK: - Public
    func changeLikeStatus() {
        guard let userId = selectedUser?.id,
            let likeStatus = selectedUser?.isLiked else {
            return
        }
        
        if likeStatus {
            requestDislikeUser(withUserId: userId)
        } else {
            requestLikeUser(withUserId: userId)
        }
    }
    
    func nextMarker() {
        selectedIndex += 1
        loadData()
    }
    
    func previousMarker() {
        selectedIndex -= 1
        loadData()
    }
    
    
    //MARK: - Variables
    fileprivate var markers: [Marker]?
    fileprivate var selectedUser: ShortUser? {
        didSet {
            if selectedUser != nil {
                delegate?.dataUpdated(user: selectedUser!)
            }
        }
    }
    fileprivate var isLiked = false
    fileprivate var selectedIndex = 0
    
    fileprivate var isInitial = true
    
    //MARK: - Private
    private func loadData() {
        
        //check markers for nil
        guard let markers = self.markers else {
                return
        }
        
        //check index is out of range
        if selectedIndex < 0 {
            selectedIndex = 0
        } else if selectedIndex > (markers.count - 1) {
            selectedIndex = (markers.count - 1)
        }
        
        //check userId for nil
        guard let userId = markers[selectedIndex].user?.id else {
            return
        }
        
        
        
        self.requestFullUserInfo(userId: userId) { (currentUser) in
            self.selectedUser = currentUser
        }
        
        
        if markers.count == 1 {
            delegate?.changeButtonVisibility(buttonType: .nextButton, isHidden: true)
            delegate?.changeButtonVisibility(buttonType: .previousButton, isHidden: true)
        } else if selectedIndex == 0 {
            delegate?.changeButtonVisibility(buttonType: .nextButton, isHidden: false)
            delegate?.changeButtonVisibility(buttonType: .previousButton, isHidden: true)
        } else if selectedIndex == (markers.count - 1) {
            delegate?.changeButtonVisibility(buttonType: .nextButton, isHidden: true)
            delegate?.changeButtonVisibility(buttonType: .previousButton, isHidden: false)
        }
        
    }
    
    private func updateData(markers: [Marker]?) {
        
        guard let existingMarkers = self.markers,
            let newMarkers = markers else {
                return
        }
        
        
        if newMarkers.count != existingMarkers.count {
            //changed
            
            var index: Int?
            //try to find current index for selected user
            for eachMarker in newMarkers {
                if eachMarker.hashValue == selectedUser?.id {
                    index = newMarkers.index(of: eachMarker)
                    break
                }
            }
            
            self.markers = newMarkers
            
            //if index exist
            if index != nil {
                //save it
                selectedIndex = index!
            } else {
                //of show first
                selectedIndex = 0
            }
            loadData()
            
        } else {
            //same group
            
            var isChanged = false
            
            //check is same group oe another
            for eachNewMarker in newMarkers {
                for eachOldMarker in existingMarkers {
                    if eachNewMarker.hashValue != eachOldMarker.hashValue {
                        isChanged = true
                    }
                }
            }
            
            self.markers = newMarkers
            
            //reload existing index data
            if isChanged {
                loadData()
            }
        }
    }
    
    
    
    
    
    //MARK: - Requests
    fileprivate func requestFullUserInfo(userId: Int,
                                         completionHandler: @escaping (_ user: ShortUser?) -> ()) {
        
        let request = APIRouter.getUser(userId: userId)
        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    let js = JSON(response)
                    //print(js)
                    if js.dictionaryObject != nil {
                        var profile = ShortUser(JSON: js.dictionaryObject!)
                        
                        let jsArray = js["photos"].array
                        guard let jsPhotoArray = jsArray else {
                            return
                        }
                        for eachPhoto in jsPhotoArray {
                            if let photoDictionary = eachPhoto.dictionaryObject {
                                let photo = Photo(JSON: photoDictionary)
                                if photo != nil {
                                    profile?.photos.append(photo!)
                                }
                            }
                        }
                        
                        if profile != nil {
                            completionHandler(profile)
                        } else {
                            completionHandler(nil)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
        }
        
        
    }
    
    fileprivate func requestLikeUser(withUserId userId: Int) {
        let request = APIRouter.likeUser(userId: userId)
        Alamofire
            .request(request)
            .responseString { (response) in
                switch response.result {
                case .success:
                    self.selectedUser?.isLiked = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
    }
    
    fileprivate func requestDislikeUser(withUserId userId: Int) {
        let request = APIRouter.unlikeUser(userId: userId)
        
        Alamofire
            .request(request)
            .responseString { (response) in
                switch response.result {
                case .success:
                    self.selectedUser?.isLiked = false
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
    }
    
    
    
}
