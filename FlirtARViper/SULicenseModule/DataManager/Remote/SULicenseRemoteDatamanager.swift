//
//  SULicenseRemoteDatamanager.swift
//  FlirtARViper
//
//  Created by on 18.09.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SULicenseRemoteDatamanager: SULicenseRemoteDatamanagerInputProtocol {
    var remoteRequestHandler:SULicenseRemoteDatamanagerOutputProtocol?
    
    func requestLicenseAgreement() {
        //TODO: Send request here
        
        let text = "Start template text"
        remoteRequestHandler?.licenseRecieved(withText: text)
//        remoteRequestHandler?.licenseRecieveError(method: APIMethod.checkEmail, error: EmailCheckError.emailNotAvailable)
        
    }
    
    func requestSaveProfile(withUser user: User) {
        let request = APIRouter.updateUserProfile(user: user)
        
        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    print(response)
                    let js = JSON(response)
                    
                    if js["first_name"] != JSON.null {
                        if js.dictionaryObject != nil {
                            ProfileService.savedUser = User(JSON: js.dictionaryObject!)
                            self.remoteRequestHandler?.profileSaved()
                        } else {
                            self.remoteRequestHandler?.profileSaveError(method: APIMethod.signUp, error: SignUpError.userResponseError)
                        }
                        
                    } else {
                        //else show error for fields
                        
                        let errors = APIParser().parseSaveProfileErrors(js: js)
                        self.remoteRequestHandler?.fillFieldsError(method: APIMethod.signUp, errors: errors)
                    }
                    
                    
                    
                case .failure(let error):
                    self.remoteRequestHandler?.profileSaveError(method: APIMethod.signUp, error: error)
                }
        }
    }
    
    func requestSavingPhotos(withPhotos photos: [UIImage]) {
        let updater = PhotoUpdateService()
        updater.uploadPhotosToServer(images: photos) { (updated, photos) in
            if updated {
                self.remoteRequestHandler?.photosUploaded(photos: photos!)
            } else {
                self.remoteRequestHandler?.photosUploadError(method: APIMethod.photos, error: PhotosUploadError.photosNotUploaded)
            }
        }
    }
    
    
}
