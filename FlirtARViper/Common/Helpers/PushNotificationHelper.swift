//
//  PushNotificationHelper.swift
//  FlirtARViper
//
//  Created by on 31.08.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import Firebase
import BRYXBanner


class PushNotificationHelper {
    
    //MARK: - Variables
    fileprivate static var bannerColor = UIColor(red:62.0/255.0, green:67.0/255.0, blue:79/255.0, alpha:0.8)
    fileprivate static var bannerFont = UIFont(name: "AvenirNext-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12)
    fileprivate static var bannerBodyColor = UIColor.white
    
    //MARK: - Public
    //MARK: In app notifications
    static func showBanner(forUserInfo userInfo: [AnyHashable : Any]) {
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let body = alert["body"] as? String {
                    
                    var banner: Banner?
                    if body.contains("Check his Profile") || body.contains("Check her Profile") {
                        
                        guard let profileIdString = userInfo["profile_id"] as? String,
                            let profileId = Int(profileIdString) else {
                                return
                        }
                        
                        
                        banner = Banner(title: nil,
                                        subtitle: body,
                                        image: nil,
                                        backgroundColor: self.bannerColor,
                                        didTapBlock: {
                                            //it's like -> show profile
                                            let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUserId: profileId)
                                            
                                            let window = (UIApplication.shared.delegate as! AppDelegate).window
                                            window?.rootViewController?.present(arProfileDetailController, animated: true, completion: nil)
                                            
                                            
                        })
                    } else {
                        banner = Banner(title: nil,
                                        subtitle: body,
                                        image: nil,
                                        backgroundColor: self.bannerColor)
                    }
                    
                    
                    
                    banner?.detailLabel.font = self.bannerFont
                    banner?.detailLabel.textColor = self.bannerBodyColor
                    banner?.titleLabel.font = self.bannerFont
                    banner?.dismissesOnTap = true
                    banner?.show(duration: 3.0)
                    
                }
            }
        }
    }
    
    //App in background and user tap on notification
    static func showProfileForNewLike(forUserInfo userInfo: [AnyHashable : Any]) {
        
        guard let aps = userInfo["aps"] as? NSDictionary,
            let alert = aps["alert"] as? NSDictionary,
            let body = alert["body"] as? String else {
                return
        }
        
        if body.contains("Check his Profile") || body.contains("Check her Profile")  {
        
            guard let profileIdString = userInfo["profile_id"] as? String,
                let profileId = Int(profileIdString) else {
                return
            }
            
            
            DispatchQueue.main.async {
                let arController = ARProfileWireframe.configureARFullProfileView(withUserId: profileId)
                let window = (UIApplication.shared.delegate as! AppDelegate).window
                window?.rootViewController?.present(arController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    //MARK: Apple Push Notifications
    //Get apple token for APNs
    static func getStringToken(fromData deviceToken: Data) -> String {
        let tokenUnits = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenUnits.joined()
        return token
    }
    
    //User tap on notification and app launch
    static func applicationLaunchedFromNotification(remote: [String:AnyObject]?) {
        let apsDictionary = remote?["aps"] as? [String:AnyObject]
        
        if let alert = apsDictionary?["alert"] as? [String:AnyObject] {
            if let body = alert["body"] as? String {
                //show full profile
                if body.contains("Check his Profile") || body.contains("Check her Profile") {
                    guard let profileIdString = remote?["profile_id"] as? String,
                        let profileId = Int(profileIdString) else {
                        return
                    }
                    
                    let arProfileDetailController = ARProfileWireframe.configureARFullProfileView(withUserId: profileId)
                    let window = (UIApplication.shared.delegate as! AppDelegate).window
                    window?.rootViewController?.present(arProfileDetailController, animated: true, completion: nil)
                    
                    
                }
            }
        }
    }
    
    
    //MARK: Firebase FCM token
    //Connect to FCM service
    static func connectToFcm(completionHandler:
        @escaping (_ connected: Bool, _ fcmToken: String?) -> ()) {
        
        //disconnect if already connected
        FIRMessaging.messaging().disconnect()
        //connect again
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("FCM: Not connected - Error: \(String(describing: error?.localizedDescription))")
                completionHandler(false, nil)
            } else {
                print("FCM: Connected")
                if let fcmToken = FIRInstanceID.instanceID().token() {
                    completionHandler(true, fcmToken)
                } else {
                    completionHandler(false, nil)
                }
            }
            
        }
    }
    
    
}
