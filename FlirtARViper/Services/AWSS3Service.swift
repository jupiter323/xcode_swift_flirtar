//
//  AWSS3Service.swift
//  FlirtARViper
//
//  Created by   on 09.08.17.
//  Copyright © 2017  . All rights reserved.
//

import Foundation
import AWSS3
import AWSCore
import Photos

class AWSS3Service {
    private let apiAccessKey = "AKIAI2HWSOP4BDR7ZJ7A"
    private let apiSercretKey = "pj2tcn3fJRjkf6Nw4x3DMo41vr4I05vrSoIf9LY3"
    private let region = AWSRegionType.USEast1
    private let bucketName = "flirtar-dev"
    
    init() {
        let credentials = AWSStaticCredentialsProvider(accessKey: apiAccessKey, secretKey: apiSercretKey)
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentials)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    
    func uploadPhoto(images: [UIImage],
                     completionHandler: @escaping (_ photoLinks: [String]) -> ()) {
        
        print("DEBUG AWS: uploadPhoto")
        print("DEBUG AWS: photos - \(images)")
        
        let uploadPhotoGroup = DispatchGroup()
        var links = [String](repeating: "", count: images.count)
        var imagesOrder = [String]()
        
        for i in 0..<images.count {
            
            let photoTuple = savePhotoLocally(image: images[i])
            guard let photoURL = photoTuple.url, let photoName = photoTuple.name else {
                return
            }
            
            imagesOrder.append(photoName + ".jpeg")
            
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            guard uploadRequest != nil else {
                return
            }
            
            uploadRequest!.body = photoURL
            uploadRequest!.key = photoName + ".jpeg"
            uploadRequest!.bucket = bucketName
            uploadRequest!.acl = .publicRead
            
            
            uploadPhotoGroup.enter()
            print("enter AWS upload")
            
            let transferManager = AWSS3TransferManager.default()
            transferManager.upload(uploadRequest!).continueWith(block: { (task) -> Any? in
                
                if let error = task.error {
                    print(error.localizedDescription)
                }
    
                if task.result != nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(uploadRequest!.bucket!).appendingPathComponent(uploadRequest!.key!)
                    
                    if publicURL != nil {
                        self.removePhotoLocally(photoURL: photoURL)
                        
                        let index = imagesOrder.index(of: uploadRequest!.key!)
                        if index != nil {
                            links[index!] = publicURL!.absoluteString
                        }
                    }
                }
                
                print("leave AWS upload")
                uploadPhotoGroup.leave()
                
                return nil
            })
            
            
        }
        
        uploadPhotoGroup.notify(queue: .main, execute: {
            print("notify: AWS all photos uploaded")
            print("=============AWS NEW: \(links)")
            completionHandler(links)
        })
        
    }
    
    
    
    func uploadVideo(videoPath: URL,
                     videoThumbnail: UIImage,
                     completionHandler: @escaping (_ url: String?, _ thumbImage: String?) -> ()) {
        
        self.uploadPhoto(images: [videoThumbnail]) { (links) in
            if links.count != 0 {
                
                let thumbImage = links.first!
                
                let uploadRequest = AWSS3TransferManagerUploadRequest()
                guard uploadRequest != nil else {
                    completionHandler(nil, nil)
                    return
                }
                
                let videoName = NSUUID().uuidString + ".mov"
                
                uploadRequest!.body = videoPath
                uploadRequest!.key = videoName
                uploadRequest!.bucket = self.bucketName
                uploadRequest!.acl = .publicRead
                
                
                let transferManager = AWSS3TransferManager.default()
                transferManager.upload(uploadRequest!).continueWith(block: { (task) -> Any? in
                    
                    if let error = task.error {
                        print(error.localizedDescription)
                    }
                    
                    if task.result != nil {
                        let url = AWSS3.default().configuration.endpoint.url
                        let publicURL = url?.appendingPathComponent(uploadRequest!.bucket!).appendingPathComponent(uploadRequest!.key!)
                        
                        if publicURL != nil {
                            completionHandler(publicURL!.absoluteString, thumbImage)
                        }
                    }
                    
                    return nil
                    
                })
                
            } else {
                completionHandler(nil, nil)
            }
        }
        
        
    }
    
    
    private func savePhotoLocally(image: UIImage) -> (url: URL?, name: String?) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if documentsURL != nil {
            let fileName = NSUUID().uuidString
            let fileURL = documentsURL!.appendingPathComponent(fileName)
            if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                try? imageData.write(to: fileURL, options: .atomic)
                return (fileURL, fileName)
            }
        }
        print("Error saving local image")
        return (nil, nil)
    }
    
    private func removePhotoLocally(photoURL: URL) {
        do {
            try FileManager.default.removeItem(at: photoURL)
        } catch {
            print("Error while removing photo local")
        }
    }
    
}







