//
//  AppDelegate.swift
//  Glimpse
//
//  Created by Nitin on 10/4/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces
import GoogleMaps
import Quickblox
import QuickbloxWebRTC
import UserNotificationsUI
import UserNotifications
import IQKeyboardManagerSwift



let kQBApplicationID:UInt = 63710
let kQBAuthKey = "cfbMFchjU7LbX2O"
let kQBAuthSecret = "sXS6tVgnOkqTRbv"
let kQBAccountKey = "5AqfvERdEMo3nUxiDGCK"

let kQBRingThickness:CGFloat = 1.0
let kQBAnswerTimeInterval:TimeInterval = 60.0
let kQBDialingTimeInterval:TimeInterval = 5.0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        IQKeyboardManager.sharedManager().enable = true
        self .configureNavigationBar()
        
        GMSServices.provideAPIKey("AIzaSyDzD-3xP1Zx-KAgvR9yfJnv2Et2HIA2dSU")
        GMSPlacesClient.provideAPIKey("AIzaSyDzD-3xP1Zx-KAgvR9yfJnv2Et2HIA2dSU")
        
        
        // Override point for customization after application launch.
        // Set QuickBlox credentials (You must create application in admin.quickblox.com).
        QBSettings.setApplicationID(kQBApplicationID)
        QBSettings.setAuthKey(kQBAuthKey)
        QBSettings.setAuthSecret(kQBAuthSecret)
        QBSettings.setAccountKey(kQBAccountKey)
        QBSettings.setKeepAliveInterval(30)
        // enabling carbons for chat
        QBSettings.setCarbonsEnabled(true)
        QBSettings.setAutoReconnectEnabled(true);
        // Enables Quickblox REST API calls debug console output.
        QBSettings.setLogLevel(QBLogLevel.debug)
        
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        
        QBRTCConfig.setAnswerTimeInterval(kQBAnswerTimeInterval)
        QBRTCConfig.setDialingTimeInterval(kQBDialingTimeInterval)
        QBRTCConfig.setStatsReportTimeInterval(1.0)
        QBRTCClient.initializeRTC()
        // Notification
        Settings.instance()
        self.registerForRemoteNotification()
        
        
        
        // Check Weather User is login or not
        
        if (UserDefaults.standard.value(forKey: EXTRA.kAPI_LOGIN_DATA) as? NSDictionary) != nil
        {
            self.loadDashboard()
        }
        else
        {
            let glimpseViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_WELCOME_VC as NSString) as! GlimpseViewController
            
            Alert.appDelegate().setIntialVC(viewController: glimpseViewController)
        }
        
        return true
    }
    
    
    //MARK: - configure NavigationBar galobaly
    func configureNavigationBar()  {
        
        // barTintColor setting
        UINavigationBar.appearance().barTintColor = Alert.colorFromHexString(hexCode:COLOR_CODE.NAVCOLOR)
        
        // TINT COLOR
        UINavigationBar.appearance().tintColor = UIColor.white
        
    
        // ATTRIBUTE COLOR WITH FONT
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                            NSFontAttributeName: UIFont(name: "Helvetica-Light", size: 16)!]
        
        // STATUS BAR
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    //MARK: - LOAD DASH BOARD FOR THE APPPLICATIONS
    func loadDashboard(){
        
        let newViewController = DashboardViewController()
        Alert.appDelegate().setIntialVC(viewController: newViewController)
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
          //  QBChat.instance.disconnect { (error) in
            
        //    }
         ServicesManager.instance().chatService.disconnect(completionBlock: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
            //let user = QBUUser()
          //  QBChat.instance.connect(with: user) { (error) in
           ServicesManager.instance().chatService.connect(completionBlock: nil)
                
           
                
       // }
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
     QBRTCClient.deinitializeRTC()
     ServicesManager.instance().chatService.disconnect(completionBlock: nil)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Glimpse")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Intial View Controller
    func setIntialVC(viewController:UIViewController) {
        
        // Add a navigation contoller into ViewController View Controller
        let viewControllerNav = UINavigationController.init(rootViewController: viewController)
        
        // make Navigation Controller as Window Root view Controller
        self.window?.rootViewController = viewControllerNav;
        // Window make Visible here
        self.window?.makeKeyAndVisible()
        
    }
    
    
    // MARK: Remote Notification Methods // <= iOS 9.x
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""
        
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        
        UserDefaults.standard.set(token, forKey: DEVICE.kDEVICE_TOKEN)
        UserDefaults.standard.synchronize()
        
        QBCore.instance().registerForRemoteNotifications(withDeviceToken: deviceToken)
        
        print("Device Token = ", token)
        // self.strDeviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    // MARK: UNUserNotificationCenter Delegate // >= iOS 10
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
    
    // MARK: Class Methods
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                    
                    
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

}

