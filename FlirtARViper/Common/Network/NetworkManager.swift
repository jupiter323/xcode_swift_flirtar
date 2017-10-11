//
//  NetworkManager.swift
//  FlirtARViper
//
//  Created by on 21.09.17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ExternalLinks: String {
    case privacyPolicy = "https://www.flirtar.co/privacy.html"
    case termsOfService = "https://www.flirtar.co/terms.html"
    case itunesLink = "itms://itunes.apple.com/app/id1272001563"
}

class NetworkManager {
    
    static var shared = NetworkManager()
    
    func sendAPIRequest(request: URLRequestConvertible,
                     completionHandler: @escaping (_ jsRequest: JSON?, _ error: Error?) -> ()) {
        Alamofire
            .request(request)
            .responseJSON { (response) in
                
                self.checkStatusCode(response: response.response)
                
                switch response.result {
                case .success(let response):
                    let js = JSON(response)
                    completionHandler(js, nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    func sendAPIRequestWithStringResponse(request: URLRequestConvertible,
                                          completionHandler: @escaping (_ error: Error?) -> ()) {
        Alamofire
            .request(request)
            .responseString { (response) in
                
                self.checkStatusCode(response: response.response)
                
                switch response.result {
                case .success:
                    completionHandler(nil)
                case .failure(let error):
                    completionHandler(error)
                }
        }
        
    }
    
    func clearURLCache() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    
    private func checkStatusCode(response: HTTPURLResponse?) {
        if let statusCode = response?.statusCode {
            //token invalid
            if statusCode == 401 {
                LocationService.shared.delegate = nil
                ProfileService.clearProfileService()
                do {
                    try CoreDataManager.shared.clearSavedUser()
                } catch {
                    print("Local DB not cleared")
                }
                
                DispatchQueue.main.async {
                    let splashScreen = SplashWireframe.configureSplashModule()
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.window?.rootViewController = splashScreen
                    appDelegate?.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    
}
