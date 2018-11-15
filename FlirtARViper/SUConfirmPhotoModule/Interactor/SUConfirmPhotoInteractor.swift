//
//  SUConfirmPhotoInteractor.swift
//  FlirtARViper
//
//  Created by  on 02.08.17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit

class SUConfirmPhotoInteractor: SUConfirmPhotoInteractorInputProtocol {
    
    weak var presenter: SUConfirmPhotoIntercatorOutputProtocol?
    
    func savePhotos(photos: [UIImage]) {
        ProfileService.localPhotos = photos
        presenter?.providePhotos(photos: photos)
    }
    
    
}
