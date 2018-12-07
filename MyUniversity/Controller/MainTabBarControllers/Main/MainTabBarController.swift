//
//  MainViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material
import XCGLogger
import RealmSwift
import RxCocoa
import RxSwift


class MainTabBarController: UITabBarController{
    
    let log = XCGLogger.default
    var notificationToken: NotificationToken?
    
    override func loadView() {
        super.loadView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = Color.grey.lighten5
        
        //set tab bar background color
        tabBar.barTintColor = App.mainColor
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for:.selected)
        UITabBar.appearance().tintColor = UIColor.black
        
        //notification to update badge value
        //NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatMessageNotification), name: NSNotification.Name(rawValue: "newMessageForMainTabVC"), object: nil)
        //check if there is unread messages in realm
        //NotificationCenter.default.addObserver(self, selector: #selector(handleunreadMessageNotification), name: NSNotification.Name(rawValue: "checkIfThereIsUnreadMessages"), object: nil)
        
        //check if there is unread message in main tabbar
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkIfThereIsUnreadMessages"), object: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let univVC = UINavigationController(rootViewController:UniversityViewController())
        //let univVC = UINavigationController(rootViewController:UniversityFABMenuController(rootViewController:UniversityViewController()))
        //let univVC = UniversityViewController()
        let univVCBarItem = UITabBarItem(title: "University", image: UIImage(named:"ic_school_white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:UIImage(named:"ic_school"))
        univVC.tabBarItem = univVCBarItem
        
        //let qandaVC = QandAFABMenuController(rootViewController:QandAViewController())
        let qandaVC = UINavigationController(rootViewController:QandAFABMenuController(rootViewController:QandAViewController()))
        let qandaVCBarItem = UITabBarItem(title: "Q&A", image: UIImage(named:"ic_info_outline_white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:UIImage(named:"ic_info_outline"))
        qandaVC.tabBarItem = qandaVCBarItem
        
        //let mentorVC = MentorFABMenuController(rootViewController:MentorViewController())
        let mentorVC = UINavigationController(rootViewController:MentorFABMenuController(rootViewController:MentorViewController()))
        let mentorVCBarItem = UITabBarItem(title: "Mentor", image: UIImage(named:"ic_face_white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:UIImage(named:"ic_face"))
        mentorVC.tabBarItem = mentorVCBarItem
        
//        let chatListVC = UINavigationController(rootViewController:ChatListViewController())
//        let chatListVCBarItem = UITabBarItem(title: "Chat", image: UIImage(named:"ic_chat_bubble_white")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage:UIImage(named:"ic_chat_bubble"))
//        chatListVC.tabBarItem = chatListVCBarItem
        
        //self.viewControllers = [univVC,qandaVC,mentorVC,chatListVC]
        self.viewControllers = [univVC,qandaVC,mentorVC]
        
    }

    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
    
    //deallocate references from memory
    deinit {
        //remove observer
        NotificationCenter.default.removeObserver(self)
        log.debug()
    }
}

extension MainTabBarController{
    
    
    
    //this is for Chatting implementation
    //if new message received from others, update badge num of chatListVC tabbar
//    @objc func handleNewChatMessageNotification(notification: NSNotification) {
//
//        log.debug("this is MainTabBarVC newMessageForMainTabVC")
//
////        self.view.window?.makeToast("세 메세지가 도착하였습니다!", duration: 0.5, position: .top, title: "New Message", image: UIImage(named:"ic_chat_white"), style: nil, completion: nil)
//
//        //if ios version is above or equal to 10.0
//        //set badge color to the red
//        if #available(iOS 10.0, *) {
//            tabBar.items![3].badgeColor = UIColor.red
//        } else {
//            //no badge color
//            // Fallback on earlier versions
//        }
//        tabBar.items![3].badgeValue = "1+"
//    }
//
//    @objc func handleunreadMessageNotification(notification: NSNotification){
//        DispatchQueue.global(qos: .userInitiated).async {
//            let realm = try! Realm()
//            let messages = realm.objects(Message.self).filter("is_read == %@","false")
//            //if there is unread message
//            if messages.count != 0{
//                DispatchQueue.main.async {
//                    self.tabBar.items?[3].badgeValue = "1+"
//                }
//            }else{
//                //all messages are read
//                DispatchQueue.main.async {
//                    self.tabBar.items?[3].badgeValue = ""
//                    self.tabBar.items?[3].badgeValue = nil
//                }
//            }
//        }
//    }
    
}
