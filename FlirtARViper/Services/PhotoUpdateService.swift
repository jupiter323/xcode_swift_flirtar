//
//  PhotoUpdateService.swift
//  FlirtARViper
//
//  Created by  on 11.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias PhotoTuple = (link: String, primary: Bool)

class PhotoUpdateService {
    
    init() {
        awsService = AWSS3Service()
    }
    
    private var awsService: AWSS3Service!
    
    func uploadPhotosToServer(images: [UIImage],
                              completionHandler: @escaping (_ uploaded: Bool,
                                                            _ photos: [Photo]?) -> ()) {
        
        print("DEBUG Photos Updater: Start update photos")
        print("DEBUG Photos Updater: AWS Service - \(awsService)")
        print("DEBUG Photos Updater: images - \(images)")
        
        awsService.uploadPhoto(images: images) { (links) in
            
            var newPhotos = [Photo]()
            let uploadPhotoGroup = DispatchGroup()
            
            
            if ProfileService.recievedPhotos.count < links.count {
                var lastUpdatedIndex = 0
                var primaryExist = false
                for i in 0..<ProfileService.recievedPhotos.count {
                    lastUpdatedIndex = i
                    //update existing
                    var updateTuple: PhotoTuple?
                    if i == 0 {
                        updateTuple = (link: links[i], primary: true)
                        primaryExist = true
                    } else {
                        updateTuple = (link: links[i], primary: false)
                    }
                    print("Enter: update photo upd & cre")
                    uploadPhotoGroup.enter()
                    self.updatePhoto(newPhoto: updateTuple!,
                                replaceId: ProfileService.recievedPhotos[i].photoID!,
                                completionHandler: { (updated, photo) in
                            if updated {
                                newPhotos.append(photo!)
                            }
                            print("Leave: update photo upd & cre")
                            uploadPhotoGroup.leave()
                    })
                }
                
                var photosForCreate = [PhotoTuple]()
                for j in lastUpdatedIndex..<links.count {
                    //post new
                    if !primaryExist {
                        photosForCreate.append((link: links[j], primary: true))
                        primaryExist = true
                    } else {
                        photosForCreate.append((link: links[j], primary: false))
                    }
                }
                
                uploadPhotoGroup.enter()
                print("Enter: update photo cre")
                self.createPhotos(photos: photosForCreate,
                                  completionHandler: { (created, photos) in
                        if created {
                            newPhotos.append(contentsOf: photos!)
                        }
                        uploadPhotoGroup.leave()
                        print("Leave: update photo cre")
                })
                
                
            } else {
                for i in 0..<ProfileService.recievedPhotos.count {
                    //update existing
                    var updateTuple: PhotoTuple?
                    if i == 0 {
                        updateTuple = (link: links[i], primary: true)
                    } else {
                        updateTuple = (link: links[i], primary: false)
                    }
                    uploadPhotoGroup.enter()
                    print("Enter: update photo upd only")
                    self.updatePhoto(newPhoto: updateTuple!,
                                     replaceId: ProfileService.recievedPhotos[i].photoID!,
                                     completionHandler: { (updated, photo) in
                            if updated {
                                newPhotos.append(photo!)
                            }
                            uploadPhotoGroup.leave()
                            print("Leave: update photo upd only")
                    })
                    
                }
            }
            
            
            uploadPhotoGroup.notify(queue: .main, execute: {
                print("notify: new photos uploaded")
                //sort photos here and completion
                
                var sortedPhotos = [Photo]()
                for i in 0..<links.count {
                    for j in 0..<newPhotos.count {
                        guard let photoLink = newPhotos[j].url else {
                            break
                        }
                        if photoLink == links[i] {
                            sortedPhotos.append(newPhotos[j])
                            break
                        }
                    }
                }
                
                print("=============Updater new: \(newPhotos)")
                print("=============Updater new sorted: \(sortedPhotos)")
                completionHandler(true, sortedPhotos)
            })
            
        }
    }
    
    
    private func createPhotos(photos: [PhotoTuple],
                              completionHandler: @escaping (_ uploaded: Bool,
                                                            _ photos:[Photo]?) -> ()) {
        
        let request = APIRouter.createUserPhotos(photos: photos)

        
        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    print(response)
                    var photosFromServer = [Photo]()
                    let js = JSON(response)
                    let jsArray = js["photos"].array
                    guard let jsPhotoArray = jsArray else {
                        completionHandler(false, nil)
                        return
                    }
                    
                    for eachPhoto in jsPhotoArray {
                        if let photoDictionary = eachPhoto.dictionaryObject {
                            let photo = Photo(JSON: photoDictionary)
                            if photo != nil {
                                photosFromServer.append(photo!)
                            }
                        }
                    }
                    completionHandler(true, photosFromServer)
                case .failure(let error):
                    print(error)
                    completionHandler(false, nil)
                }
        }
    }
    
    private func updatePhoto(newPhoto: PhotoTuple,
                             replaceId: Int,
                              completionHandler: @escaping (_ updated: Bool,
                                                            _ photo: Photo?) -> ()) {
        
        
        let request = APIRouter.updatePhoto(photoId: replaceId, newPhoto: newPhoto)


        Alamofire
            .request(request)
            .responseJSON { (response) in
                switch response.result {
                case .success(let response):
                    print(response)
                    
                    let js = JSON(response)
                    guard let jsPhoto = js.dictionaryObject else {
                        return
                    }
                    
                    let photo = Photo(JSON: jsPhoto)
                    completionHandler(true, photo)
                    
                case .failure(let error):
                    print(error)
                    completionHandler(false, nil)
                }
        }
        
    }
    
    
    //MARK: - Helpers
    private func configureCreateUserPhotos(photos: [PhotoTuple]) -> [String: Any] {
        var photosDictionary = [String: [Any]]()
        
        var photosArray = [[ : ]]
        photosArray.removeAll()
        for i in 0..<photos.count {
            
            if photos[i].primary {
                let primaryPhoto = ["url":photos[i].link,
                                    "primary": photos[i].primary] as [String: Any]
                photosArray.append(primaryPhoto)
            } else {
                let photo = ["url": photos[i].link] as [String: Any]
                photosArray.append(photo)
            }
            
        }
        
        photosDictionary["photos"] = photosArray
        
        return photosDictionary
    }
    
    private func configureUserPhotoForUpdate(photo: PhotoTuple) -> [String: Any] {
        return ["url":photo.link,
                "primary":photo.primary]
    }

    
    
    
    
    
    
    
    
    
    
}
