//
//  SUProfileInfoRemoteDatamanager.swift
//  
//
//  Created by on 20.09.17.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class SUProfileInfoRemoteDatamanager: SUProfileInfoRemoteDatamanagerInputProtocol {
    
    weak var remoteRequestHandler:SUProfileInfoRemoteDatamanagerOutputProtocol?
    
    func requestSignUp(withUser user: User) {
        let request = APIRouter.updateUserProfile(user: user)
        
        NetworkManager
        .shared
        .sendAPIRequest(request: request) { (js, error) in
            if error != nil {
                self.remoteRequestHandler?.signUpError(method: APIMethod.signUp, error: error!)
            } else {
                
                guard js!["first_name"] != JSON.null else {
                    let errors = APIParser().parseSaveProfileErrors(js: js!)
                    self.remoteRequestHandler?.fillFieldsError(method: APIMethod.signUp, errors: errors)
                    return
                }
                
                if js!.dictionaryObject != nil {
                    ProfileService.savedUser = User(JSON: (js?.dictionaryObject)!)
                    self.remoteRequestHandler?.signedUp()
                } else {
                    self.remoteRequestHandler?.signUpError(method: APIMethod.signUp, error: SignUpError.userResponseError)
                }
                
                
                
            }
        }
        
    }
    
    func requestSavingPhotos(withPhotos photos: [UIImage]) {
        print("DEBUG SUProfile RemoteDatamanager: Photos save start")
        let updater = PhotoUpdateService()
        updater.uploadPhotosToServer(images: photos) { (updated, uploadedPhotos) in
            if updated {
                print("DEBUG SUProfile  RemoteDatamanager: Photos saved - \(uploadedPhotos!)")
                
                if photos.count == uploadedPhotos?.count {
                    self.remoteRequestHandler?.photosUploaded(photos: uploadedPhotos!)
                } else {
                    self.remoteRequestHandler?.photosUploadError(method: APIMethod.photos, error: PhotosUploadError.photosNotUploaded)
                }
            
            } else {
                print("DEBUG SUProfile  RemoteDatamanager: Photos save error)")
                self.remoteRequestHandler?.photosUploadError(method: APIMethod.photos, error: PhotosUploadError.photosNotUploaded)
            }
        }
    }
}
