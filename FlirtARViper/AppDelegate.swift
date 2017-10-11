//
//  AppDelegate.swift
//  FlirtARViper
//
//  Created on 01.08.17.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleMaps
import UserNotifications
import FacebookCore
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    fileprivate var bannerColor = UIColor(red:62.0/255.0, green:67.0/255.0, blue:79/255.0, alpha:0.8)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Keyboard manager
        IQKeyboardManager.sharedManager().enable = true
        
        //GoogleMaps
        GMSServices.provideAPIKey(API.mapsApi)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        if ProfileService.isUserLoggedIn() {
            //load main tab
            let tabBarController = TabBarWireframe.configureTabBar()
            window?.rootViewController = tabBarController
        } else {
            //else launch
            let splash = SplashWireframe.configureSplashModule()
            window?.rootViewController = splash
        }
        
        window?.makeKeyAndVisible()
        
        
        //Push notifications
        registerForPushNotifications(application: application)
        
        //Firebase Integration
        FIRApp.configure()
        FIRMessaging.messaging().remoteMessageDelegate = self
        
        //Firebase Analytics
        //Production - TRUE
        //Debug - FALSE
        FIRAnalyticsConfiguration.sharedInstance().setAnalyticsCollectionEnabled(false)
        
        //Clear badge
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        BadWordHelper.shared.configureContent()
        
        //if launch from notification
        if launchOptions != nil {
            
            if let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String:AnyObject]? {
                
                PushNotificationHelper.applicationLaunchedFromNotification(remote: remote)
                
            }
        }
        
        //FB
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("DEBUG Delegate: Resign active")
        RateAppHelper.shared.stopCount()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("DEBUG Delegate: Enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        print("DEBUG Delegate: Enter foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("DEBUG Delegate: Became active")
        RateAppHelper.shared.startCount()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        RateAppHelper.shared.stopCount()
        print("DEBUG Delegate: Terminate")
    }
    
    
    // MARK: - Notifications
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = PushNotificationHelper.getStringToken(fromData: deviceToken)
        print("Apple Token: \(token)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register push notifications for device: \(error.localizedDescription)")
    }
    
    
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]) { (granted, error) in
                    guard granted else { return }
                    self.getNotificationsSettings(application: application)
            }
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification(_:)),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
    }
    
    //FCM token refreshed
    func tokenRefreshNotification(_ notification: Notification) {
        PushNotificationHelper.connectToFcm { (isConnected, fcmToken) in
            if isConnected {
                ProfileService.fcmToken = fcmToken
            }
        }
    }
    
    func getNotificationsSettings(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        DispatchQueue.main.async {
            if application.applicationState == .inactive || application.applicationState == .background {
                //application background
                PushNotificationHelper.showProfileForNewLike(forUserInfo: userInfo)
                
            } else {
                //application foreground
                PushNotificationHelper.showBanner(forUserInfo: userInfo)
            }
        }
        
        
    }
    
    

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "FlirtARViper", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [NSInferMappingModelAutomaticallyOption: true,
                           NSMigratePersistentStoresAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    

    // MARK: - Core Data Saving support

    func saveContext () {
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
        
        
    }

}

extension AppDelegate: FIRMessagingDelegate {
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

