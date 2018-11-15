//
//  TabBarViewController.swift
//  FlirtARViper
//
//  Created by  on 04.08.17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

enum Tabs: Int {
    case map
    case like
    case ar
    case messages
    case profile
    
    var tabImage: UIImage? {
        return UIImage(named: "tab-\(String(describing: self))")
    }
    
    static let tabsInOrder = [map, like, ar, messages, profile]
}

class TabBarViewController: RAMAnimatedTabBarController, TabBarViewProtocol {
    
    
    //MARK: - General variables
    fileprivate let imageOffset:CGFloat = -4.0
    fileprivate let selectedItemColor = UIColor(red: 201/255, green: 35/255, blue: 61/255, alpha: 1.0)
    fileprivate var badgeCount = 0 {
        didSet {
            guard let items = self.tabBar.items else {
                return
            }
            
            if self.selectedIndex != 3 {
                
                if items.count >= 4 {
                    var badgeValues = [Int](repeating: 0, count: items.count)
                    badgeValues[3] = badgeCount
                    self.setBadges(badgeValues: badgeValues)
                }
            } else {
                let badgeValues = [Int](repeating: 0, count: items.count)
                self.setBadges(badgeValues: badgeValues)
            }
        }
    }
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        
        PushNotificationHelper.connectToFcm { (isConnected, fcmToken) in
            if isConnected {
                ProfileService.fcmToken = fcmToken
                self.presenter?.registerDeviceForPushNotifications()
            }
        }
    }
    
    //MARK: - TabBarViewProtocol
    var presenter: TabBarPresenterProtocol?
    
    func newMessageCome() {
        if self.selectedIndex != 3 {
            badgeCount += 1
        }
    }
    
    //MARK: - Helpers
    private func configureTabs() {
        let mapTab = MapTabWireframe.configureMapTabView()
        let mapItem = RAMAnimatedTabBarItem(title: nil, image: Tabs.tabsInOrder[0].tabImage, tag: Tabs.tabsInOrder[0].rawValue)
        mapItem.animation = RAMBounceAnimation()
        mapItem.yOffSet = imageOffset
        mapItem.animation.iconSelectedColor = selectedItemColor
        mapTab.tabBarItem = mapItem
        
        
        
        let likeDislikeTab = LikeDislikeTabWireframe.configureLikeDislikeTabView()
        let likeDislikeItem = RAMAnimatedTabBarItem(title: nil, image: Tabs.tabsInOrder[1].tabImage, tag: Tabs.tabsInOrder[1].rawValue)
        likeDislikeItem.animation = RAMBounceAnimation()
        likeDislikeItem.yOffSet = imageOffset
        likeDislikeItem.animation.iconSelectedColor = selectedItemColor
        likeDislikeTab.tabBarItem = likeDislikeItem
        
        
        
        let arTab = ARTabMainWireframe.configureARTabView()
        let arTabItem = RAMAnimatedTabBarItem(title: nil, image: Tabs.tabsInOrder[2].tabImage, tag: Tabs.tabsInOrder[2].rawValue)
        arTabItem.animation = RAMBounceAnimation()
        arTabItem.yOffSet = imageOffset
        arTabItem.animation.iconSelectedColor = selectedItemColor
        arTab.tabBarItem = arTabItem
        
        
        
        let messagesTab = MessagesMainTabWireframe.configureMessagesMainTapView()
        let messagesItem = RAMAnimatedTabBarItem(title: nil, image: Tabs.tabsInOrder[3].tabImage, tag: Tabs.tabsInOrder[3].rawValue)
        messagesItem.animation = RAMBounceAnimation()
        messagesItem.yOffSet = imageOffset
        messagesItem.animation.iconSelectedColor = selectedItemColor
        messagesTab.tabBarItem = messagesItem
        
        
        let profileTab = ProfileMainTabWireframe.configureProfileMainTapView()
        let profileItem = RAMAnimatedTabBarItem(title: nil, image: Tabs.tabsInOrder[4].tabImage, tag: Tabs.tabsInOrder[4].rawValue)
        profileItem.animation = RAMBounceAnimation()
        profileItem.yOffSet = imageOffset
        profileItem.animation.iconSelectedColor = selectedItemColor
        profileTab.tabBarItem = profileItem
        
        
        self.viewControllers = [mapTab, likeDislikeTab, arTab, messagesTab, profileTab]
    }
    
    func clearBadgeNumber() {
        badgeCount = 0
    }

}
