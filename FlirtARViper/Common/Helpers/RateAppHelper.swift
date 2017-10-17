//
//  RateAppHelper.swift
//  FlirtARViper
//
//  Created by on 05.10.2017.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

enum RateAppKeys: String {
    case isElapsed = "isElapsed"
    case timeLeft = "timeleft"
}

class RateAppHelper {
    //MARK: - Init
    static var shared = RateAppHelper()
    
    init() {
        timeleft = initialTime
    }
    
    //MARK: - Variables
    fileprivate var isElapsed = false
    fileprivate let initialTime = 5*60*60
    fileprivate var timeleft: Int! //time in seconds
    fileprivate var timer: Timer?
    
    //MARK: - Public
    func startCount() {
        restoreState()
        
        if isElapsed == true {
            return
        }
        
        if !isElapsed && timeleft == 0 {
            timeleft = initialTime
        }
        
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(timerMinus),
                                     userInfo: nil,
                                     repeats: true)
        
        
    }
    
    func stopCount() {
        timer?.invalidate()
        timer = nil
        saveCurrentState()
    }
    
    //MARK: - Private
    private func saveCurrentState() {
        UserDefaults.standard.set(isElapsed, forKey: RateAppKeys.isElapsed.rawValue)
        UserDefaults.standard.set(timeleft, forKey: RateAppKeys.timeLeft.rawValue)
    }
    
    private func restoreState() {
        let isElapsed = UserDefaults.standard.bool(forKey: RateAppKeys.isElapsed.rawValue)
        let timeleft = UserDefaults.standard.integer(forKey: RateAppKeys.timeLeft.rawValue)
        self.isElapsed = isElapsed
        self.timeleft = timeleft
    }
    
    private func timeOut() {
        isElapsed = true
        UserDefaults.standard.set(isElapsed, forKey: RateAppKeys.isElapsed.rawValue)
    }
    
    private func showRateAppView() {
        let mainController = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        
        //if user logged in and using application -> show rateapp
        if mainController is TabBarViewController {
            let mainView = mainController?.view
            let rateApp = RateAppNotificationView(frame: UIScreen.main.bounds)
            rateApp.configureView(withTitle: "Rate",
                                  subTitle: "Tap the number of stars you'd give us on a scale from 1-5",
                                  openAppStore: true)
            mainView?.addSubview(rateApp)
        } else {
            //restart timer
            UserDefaults.standard.set(false, forKey: RateAppKeys.isElapsed.rawValue)
            UserDefaults.standard.set(0, forKey: RateAppKeys.timeLeft.rawValue)
            startCount()
        }
    }
    
    @objc private func timerMinus() {
        if self.timeleft > 0 {
            self.timeleft = self.timeleft - 1
        } else if self.timeleft == 0 {
            //present window
            timer?.invalidate()
            timer = nil
            timeOut()
            showRateAppView()
        }
    }
    
    
    
    
}
