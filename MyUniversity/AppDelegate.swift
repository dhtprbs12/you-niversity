//
//  AppDelegate.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import UIKit
import XCGLogger
import Reachability
import PKHUD
import RealmSwift
import UserNotifications
import DropDown
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var log = XCGLogger.default
    let userDefaults = UserDefaults.standard
    var auth_protoCall : GRPCProtoCall?
    var update_active_protoCall : GRPCProtoCall?
    let dateFormatter : DateFormatter = DateFormatter()
    
    
    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!
    //let reachability = Reachability(hostname: "ec2-18-144-33-164.us-west-1.compute.amazonaws.com:9000")!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "x"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 3 days
        //ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * 3
        // 1 day
        ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * 1
        // Default value is 60 * 60 * 24 * 7, which means 1 week.
        //Set this value to a negative value (like -1) will make the disk cache never expiring.
        
        // 30 second
        ImageDownloader.default.downloadTimeout = 10.0
        // Default value is 15
        
        //log.debug("UUID:\(UIDevice.current.identifierForVendor!.uuidString)")
        
        //log.debug("Realm path:\(Realm.Configuration.defaultConfiguration.fileURL)")
        // Override point for customization after application launch.
        
        //self.window?.rootViewController = MainTabBarController()
        
        //if there exists user_id in realm, go to MainViewController
        updateActive(value: 1)
        
        let realm = try! Realm()

        if let user = realm.objects(UserInfo.self).first{
            //log.debug("a:\(user_id)")
            if CheckNetworkConnection.isConnectedToNetwork(){
                let request = AuthRequest()
                request.token = user.token
                
                GRPC.sharedInstance.authorizedUser.auth(with: request, handler: {
                    (res,err) in

                    if res != nil{
                        if (res?.isExist == "true"){
                            self.userDefaults.set(Int((res?.userId)!), forKey: "user_id")
                            if self.userDefaults.bool(forKey: "login"){
                                //if user is login
                                //go to mainview
                                
                                self.window?.rootViewController = MainTabBarController()
                            }else{
                                //go to login
                                self.window?.rootViewController = LoginViewController()
                                
                            }
                            //self.auth_protoCall?.finishWithError(nil)
                        }else{
                            //go to logoview
                            self.window?.rootViewController = LoginViewController()
    
                        }
                    }else{
                        //self.auth_protoCall?.finishWithError(err)
                        self.log.debug("Update Active Error:\(err)")
                        if(err != nil){
                        self.window?.rootViewController?.view.window?.makeToast("Auth Error", duration: 1.0, position: CSToastPositionBottom)
                        }
                        
                    }
                    //need to cancel request no matter succeeded or failed
                    //GRPC.sharedInstance.rpcCall.cancel()
                })
                //auth_protoCall?.timeout = App.timeout
                //auth_protoCall?.start()
            }else{
                self.window?.rootViewController?.view.window?.makeToast("Check your network 0", duration: 1.0, position: CSToastPositionBottom)
            }

        }else{
            //log.debug("b")
            //go to logoview
            
            self.window?.rootViewController = LogoViewController()
            
        }
        
        initLog()
        DropDown.startListeningToKeyboard()
        
        //**************************** Push service start *****************************/
        
        // iOS 10 support
        if #available(iOS 10, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
        
        //Register network change notification
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            self.log.debug("could not start reachability notifier")
            //print("could not start reachability notifier")
        }
        
        //check if user set push notification
        checkPushNotificationSetting()
        //default return value of this function
        return true
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let realm = try! Realm()
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //log.debug("device_token:\(deviceTokenString)")
        if let user = realm.objects(UserInfo.self).first{
            //if user exists in realm, already registered
            if let device_token = userDefaults.string(forKey: "deviceToken"){
                //if token exists in userDefaults, compare them
                self.log.debug()
                if device_token.isEmpty || device_token != deviceTokenString{
                    //they are different, update
                    self.log.debug()
                    userDefaults.set(deviceTokenString, forKey: "deviceToken")
                    
                    //update token in server
                    if CheckNetworkConnection.isConnectedToNetwork(){
                        let request = UpdateAppleTokenRequest()
                        request.userId = Int64(user.user_id)
                        request.token = device_token
                        var protoCall : GRPCProtoCall?
                        GRPC.sharedInstance.authorizedUser.updateAppleToken(with:request,handler:{
                            (res,err) in
                            if res != nil{
                                //protoCall?.finishWithError(nil)
                            }else{
                                self.log.debug("Update Token Error: \(err)")
                                //protoCall?.finishWithError(err)
                                if(err != nil){
                                    self.window?.rootViewController?.view.window?.makeToast("Update Token Error", duration: 1.0, position: CSToastPositionBottom)
                                }
                            }
                        })
                        //protoCall?.timeout = App.timeout
                        //protoCall?.start()
                    }else{
                        self.window?.rootViewController?.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                
            }else{
                //device token does not exist in userDefault, store
                //set deviceToken into UserDefaults
                //this token is for APN only
                self.log.debug()
                userDefaults.set(deviceTokenString, forKey: "deviceToken")
            }
        }else{
            //not registered, just store token into userDefaults
            self.log.debug()
            userDefaults.set(deviceTokenString, forKey: "deviceToken")
        }
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        log.debug("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        if (data as NSDictionary? as! [String:Any]?) != nil{
            
            let messageObject = data.first?.value as! [String: Any]
            let user_id = messageObject["user_id"] as? Int
            let receiver_id = messageObject["receiver_id"] as? Int
            //if push object is that I created, do not update badge of bell icon in UniversityViewController
            if user_id == userDefaults.integer(forKey: "user_id") && receiver_id == userDefaults.integer(forKey: "user_id"){
                
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newCommentForUnivVC"), object: nil)
            }
        }else{
            log.debug("Error: data is nil didReceiveRemoteNotification")

        }
    }
    
    fileprivate func initLog() {
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: nil)
        
    }
    //function to check if network is reachable
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            self.log.debug()
            //self.window?.rootViewController?.view.window?.makeToast("Reachable via WiFi", duration: 2.0, position: CSToastPositionBottom)
            
        case .cellular:
            self.log.debug()
            //self.window?.rootViewController?.view.window?.makeToast("Reachable via Cellular", duration: 2.0, position: CSToastPositionBottom)
            
        case .none:
            self.log.debug()
            //self.window?.rootViewController?.view.window?.makeToast("Network not reachable", duration: 2.0, position: CSToastPositionBottom)
            
        }
    }
    
    func checkPushNotificationSetting(){
        //check if user set push notification
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { settings in
                
                switch settings.authorizationStatus {
                    
                case .notDetermined:
                    break
                // Authorization request has not been made yet
                case .denied:
                    
                    // User has denied authorization.
                    self.window?.rootViewController?.view.window?.makeToast("You've disabled push notification for this app. Go to settings & privacy to re-enable", duration: 5.0, position: CSToastPositionCenter)
                    
                    break
                // You could tell them to change this in Settings
                case .authorized:
                    break
                    // User has given authorization.
                case .provisional:
                    break
                }
            })
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                print("APNS-YES")
            } else {
                print("APNS-NO")
                self.window?.rootViewController?.view.window?.makeToast("You've disabled push notification for this app. Go to settings & privacy to re-enable", duration: 5.0, position: CSToastPositionCenter)
            }
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.log.debug()
        updateActive(value: 0)


    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //this get called after applicationWillResignActive
        self.log.debug()

       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        log.debug()
        updateActive(value: 1)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        log.debug()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let realm = try! Realm()
        if let user = realm.objects(UserInfo.self).first{
            
            let request = AppAboutTerminatingRequest()
            request.userId = Int64(user.user_id)
            GRPC.sharedInstance.authorizedUser.appAboutTerminating(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    
                }else{
                    NSLog("Terminating Error:\(err)")
                    print("Terminating Error:\(err)")
                    
                }
            })
        }
        
        //remove observer and stop hearing network notification
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    //all view controller 세로로 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    func updateActive(value:Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            
            let request = ActiveRequest()
            request.userId = Int64(userDefaults.integer(forKey: "user_id"))
            request.activeValue = value
            
            GRPC.sharedInstance.authorizedUser.updateActive(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.update_active_protoCall?.finishWithError(nil)
                }else{
                    //self.update_active_protoCall?.finishWithError(err)
                    self.log.debug("Update Active Error:\(err)")
                    if(err != nil){
                        if((err?.localizedDescription)! != "OS Error"){
                            self.window?.rootViewController?.view.window?.makeToast("Update Active Error:", duration: 1.0, position: CSToastPositionBottom)
                        }
                    }
                }
            })
            //update_active_protoCall?.timeout = App.timeout
            //update_active_protoCall?.start()
        }else{
            self.window?.rootViewController?.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }

}

