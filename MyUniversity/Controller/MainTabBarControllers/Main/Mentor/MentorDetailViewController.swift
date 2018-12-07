//
//  MentorDetailViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 29..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import RealmSwift
import XCGLogger
import Material
import PKHUD

class MentorDetailViewController: FormViewController{
    
    let userDefault = UserDefaults.standard
    var object : MentorObject?
    let log = XCGLogger.default
    var favoriteBtn : UIBarButtonItem!
    var check_deleted_protoCall : GRPCProtoCall?
    var touch_protoCall : GRPCProtoCall?
    var send_protoCall : GRPCProtoCall?
    var mentor_count_protoCall : GRPCProtoCall?
    let choco_realm = try! Realm()
    let countButton = SSBadgeButton()
    var countButtonItem: UIBarButtonItem!
    
    //date
    let dateFormatter : DateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let decoded  = userDefault.object(forKey: "mentor") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? MentorObject
        //this is to get comments of mentor
        self.title = object?.mentor_nickname
        self.view.backgroundColor = UIColor.clear
        //default setting for labelrow
        LabelRow.defaultCellSetup = {string, row in
            string.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            string.textLabel?.adjustsFontSizeToFitWidth = true
            string.textLabel?.numberOfLines = 0
            string.detailTextLabel?.adjustsFontSizeToFitWidth = true
            string.detailTextLabel?.numberOfLines = 0
            
        }
        
        form
            //Mentor's Image section
            +++ Section(){ section in
            section.header = {
                var header = HeaderFooterView<UIImageView>(.callback({
                    let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150))
                    view.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\((self.object?.mentor_profileurl)!)"),completionHandler:{
                        (image, error, cacheType, imageUrl) in
                        //if fails image == nil
                        if(image == nil){
                            view.image = UIImage(named: "standford")
                        }else{
                            view.image = image
                        }
                        
                    })
                    return view
                }))
                header.height = { 150 }
                return header
            }()
            }

            //Mentor information section
            +++ Section("Mentor Introduction")
            
                <<< LabelRow(){
                    $0.title = "Name"
                    $0.value = object?.mentor_nickname
                    
                }
                <<< LabelRow(){
                    $0.title = "University"
                    $0.value = object?.mentor_university
                    
                }
                <<< LabelRow(){
                    $0.title = "Major"
                    $0.value = object?.mentor_major
                    
                }
//                <<< LabelRow(){
//                    $0.title = "Sex"
//                    $0.value = object?.mentor_sex
//                    
//                }
//                <<< LabelRow(){
//                    $0.title = "Age"
//                    $0.value = object?.mentor_age
//                    
//                }
                <<< TextAreaRow() {
                    $0.placeholder = "\((object?.mentor_introduction)!)"
                    $0.cell.placeholderLabel?.textColor = UIColor.black
                    $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                    $0.disabled = true
                }
            
            //Mentoring Information
            +++ Section("Mentoring Information")
                
                <<< TextAreaRow() {
                    $0.placeholder = object?.mentor_information
                    $0.cell.placeholderLabel?.textColor = UIColor.black
                    $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                    $0.disabled = true
                }
            
            //Who can be mentored?
            +++ Section("Who Can Be Mentored?")
        
                <<< LabelRow(){
                    $0.title = self.convertString(string: (object?.mentor_mentoring_area)!)
                }
            
            //Mentoring Field
            +++ Section("Mentoring Field")
                <<< LabelRow(){
                    $0.title = self.convertString(string: (object?.mentor_mentoring_field)!)
                    
                }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        //this is to show comments on this mentor
        countButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        countButton.setImage(Icon.cm.menu, for: .normal)
        countButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        countButton.addTarget(self, action: #selector(tableViewBtnTapped), for: .touchUpInside)
        countButtonItem = UIBarButtonItem(customView: countButton)
        
        //if the mentor_id already saved in UserDefault, show full heart
        if let arr = userDefault.object(forKey: "favoriteMentors") as? [Int]{
            if arr.contains((object?.mentor_id)!){
                favoriteBtn = UIBarButtonItem.init(image: UIImage(named: "ic_favorite_white"), style: .done, target: self, action: #selector(favoriteBtnTapped))
            }else{
                favoriteBtn = UIBarButtonItem.init(image: UIImage(named: "outline_favorite_border_white_24dp"), style: .done, target: self, action: #selector(favoriteBtnTapped))
            }
        }else{//if not, show default
            favoriteBtn = UIBarButtonItem.init(image: UIImage(named: "outline_favorite_border_white_24dp"), style: .done, target: self, action: #selector(favoriteBtnTapped))
        }
 
        self.navigationItem.rightBarButtonItems = [countButtonItem,favoriteBtn]
        loadMentorCommentsCount(mentor_id: Int64((object?.mentor_id)!))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //when it goes back to MentorViewController, delete userDefault
        if (self.isMovingFromParentViewController) {
            self.log.debug()
            self.userDefault.removeObject(forKey: "mentor")
            self.userDefault.removeObject(forKey: "mentor_comment")
        }
    }
}


//extension
extension MentorDetailViewController{
    
    func loadMentorCommentsCount(mentor_id:Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetMentorCommentsCountRequest()
            request.mentorId = mentor_id
            
            GRPC.sharedInstance.authorizedUser.getMentorCommentsCount(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.mentor_count_protoCall?.finishWithError(nil)
                    self.countButton.badge = "\((res?.count)!)"
                }else{
                    self.log.debug("Get Mentor Comments Count Error:\(err)")
                    //self.mentor_count_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Mentor Comments Count Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //mentor_count_protoCall?.timeout = App.timeout
            //mentor_count_protoCall?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    
    @objc func tableViewBtnTapped(){
        let mentorCommentTableViewVC = MentorCommentTableViewController()
        mentorCommentTableViewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mentorCommentTableViewVC, animated: true)
    }
    
    @objc func favoriteBtnTapped(){
        //set user's favorite mentors into UserDefault
        if var arr = userDefault.object(forKey: "favoriteMentors") as? [Int]{
            //if there is already mentor_id in arr,ignore
            if arr.contains((object?.mentor_id)!){
                
            }else{
                
                arr.append((object?.mentor_id)!)
                userDefault.set(arr, forKey: "favoriteMentors")
                userDefault.synchronize()
            }
        }else{//if there is no value stored before
            
            var arr = [Int]()
            arr.append((object?.mentor_id)!)
            userDefault.set(arr, forKey: "favoriteMentors")
            userDefault.synchronize()
        }
        //update mentor touch count
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = MentorTouchRequest()
            request.mentorId = Int64((object?.mentor_id)!)
            request.indicator = "favorite"
            GRPC.sharedInstance.authorizedUser.mentorTouch(with: request, handler: {
                (res, err) in
                
                if res != nil{
                    //self.touch_protoCall?.finishWithError(nil)
                    DispatchQueue.main.async {
                        self.favoriteBtn.image = UIImage(named:"ic_favorite_white")
                    }
                    
                }else{
                    
                    self.log.debug("Touch Favorite Mentors Error:\(err)")
                    //self.touch_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Touch Favorite Mentors Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            
            //touch_protoCall?.timeout = App.timeout
            //touch_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
        
    }
    
    func convertString(string:String) -> String{
        let arr : [String] = string.components(separatedBy: ",")
        var result : String = ""
        for i in 0..<arr.count{
            //if it is first insertion, no newline character
            if i == 0{
                result = result + arr[i] + " student"
            }else{
                result = result + "\n" + arr[i] + " student"
            }
        }
        return result
    }
    
//    @objc func chatBtnTapped(){
//        //check first if user has enough choco to send a message to a mentor
//
////        if let user = choco_realm.objects(UserInfo.self).first{
////            if user.coin < 5{
////                let alertController = UIAlertController(title: "Caution", message: "You don't have enough coin, charge it! \nMy coin: \(user.coin)", preferredStyle: .alert)
////
////                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in //confirm button clicked
////                }
////                alertController.addAction(confirmAction)
////                self.present(alertController, animated: true, completion: nil)
////                return
////            }
////        }else{
////            //user does not exist in realm.
////            let alertController = UIAlertController(title: "Caution", message: "Seems like there is something wrong on your data. Try Again!", preferredStyle: .alert)
////
////            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in //confirm button clicked
////            }
////            alertController.addAction(confirmAction)
////            self.present(alertController, animated: true, completion: nil)
////            return
////        }
//
//        //date
//        let dateFormatter : DateFormatter = DateFormatter()
//        let date = Date()
//        var dateString = String()
//        //set dateFormat
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateString = dateFormatter.string(from: date)
//
//        let alertController = UIAlertController(title: "Start to Chat", message: "Please, write here.", preferredStyle: .alert)
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Type within 30 characters"
//        }
//        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in //confirm button clicked
//
//            if (alertController.textFields?[0]) != nil || !(alertController.textFields?[0].text?.isEmpty)!{
//
//                if CheckNetworkConnection.isConnectedToNetwork(){
//                    //check if mentor deleted before sending message
//                    let request = CheckIfItsDeletedRequest()
//                    request.id_p = Int64((self.object?.mentor_id)!)
//                    request.type = Int64(2)
//                    self.check_deleted_protoCall = GRPC.sharedInstance.authorizedUser.rpcToCheckIfItsDeleted(with: request, handler: {
//                        (res,err) in
//
//                        if res != nil{
//                            self.check_deleted_protoCall?.finishWithError(nil)
//                            if(res?.isDeleted == "true"){
//                                self.view.window?.makeToast("This Mentor Just Deleted", duration: 1.5, position: CSToastPositionBottom)
//                            }else{
//                                let realm = try! Realm()
//                                let request = SendMessageRequest()
//                                request.conversationId = 0
//                                request.senderId = Int64(self.userDefault.integer(forKey: "user_id"))
//                                request.receiverId = Int64((self.object?.user_id)!)
//                                request.senderName = (realm.objects(UserInfo.self).first?.nickname)!
//                                request.message = alertController.textFields?[0].text?.trimmed
//                                request.messageType = "TEXT"
//                                request.createdAt = dateString
//                                self.sendMessage(request: request)
//                            }
//                        }else{
//                            self.log.debug("Check Mentor Deleted Error:\(err)")
//                            self.check_deleted_protoCall?.finishWithError(err)
//                            if(err != nil){
//                                self.view.window?.makeToast("Check Mentor Deleted Error", duration: 1.0, position: CSToastPositionBottom)
//                            }
//                        }
//                    })
//                    self.check_deleted_protoCall?.timeout = App.timeout
//                    self.check_deleted_protoCall?.start()
//                }else{
//
//                    self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
//                }
//
//            }else{
//                //user typed nothing
//            }
//        }//end of confirmAction callback function
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
//    }

    
//    func sendMessage(request: SendMessageRequest){
//        let send_request = request
//        send_protoCall = GRPC.sharedInstance.authorizedUser.rpcToSendMessage(with: send_request, handler: {
//            (res,err) in
//            
//            if res != nil{
//                self.send_protoCall?.finishWithError(nil)
//                //store into just sent message
//                DispatchQueue.global().async {
//                    //store sending message into Realm
//                    let messageRealm = try! Realm()
//                    try! messageRealm.write {
//                        let realmMessage = Message()
//                        realmMessage.message_id = Int((res?.message.messageId)!)
//                        realmMessage.conversation_id = Int((res?.message.conversationId)!)
//                        realmMessage.sender_id = Int((res?.message.senderId)!)
//                        realmMessage.receiver_id = Int((res?.message.receiverId)!)
//                        realmMessage.sender_name = (res?.message.senderName)!
//                        realmMessage.message_type = (res?.message.messageType)!
//                        realmMessage.message =  (res?.message.message)!
//                        realmMessage.created_at = self.dateFormatter.date(from: (res?.message.createdAt)!)
//                        realmMessage.is_read = "true"
//                        messageRealm.create(Message.self, value: realmMessage, update: false)
//                        
//                    }
//                }
//                self.view.window?.makeToast("Successfully, Sent the Message", duration: 1.0, position: CSToastPositionBottom)
//            }else{
//                
//                self.log.debug("Start Chat Error:\(err)")
//                self.send_protoCall?.finishWithError(err)
//                if(err != nil){
//                     self.view.window?.makeToast("Start Chat Error", duration: 1.0, position: CSToastPositionBottom)
//                }
//            }
//        })
//        send_protoCall?.timeout = App.timeout
//        send_protoCall?.start()
//    }
}


