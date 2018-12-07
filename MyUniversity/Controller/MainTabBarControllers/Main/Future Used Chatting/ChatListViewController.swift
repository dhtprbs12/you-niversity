////
////  ChatViewController.swift
////  MyUniversity
////
////  Created by SekyunOh on 2018. 4. 12..
////  Copyright © 2018년 SekyunOh. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Material
//import XCGLogger
//import RealmSwift
//import Kingfisher
//
//class ChatListViewController:UITableViewController{
//    
//    //var refresh = UIRefreshControl()
//    let log = XCGLogger.default
//    let userDefault = UserDefaults.standard
//    //array for store mentor object
//    var conversations = [ConversationObject]()
//    let processor = RoundCornerImageProcessor(cornerRadius: 20)
//    //getLastMessage_protoCall does not have to be finished every time, error occurs
//    var getLastMessage_protoCall : GRPCProtoCall?
//    var getConversation_protoCall : GRPCProtoCall?
//    var deleteConversation_protoCall : GRPCProtoCall?
//    var joinConversation_protoCall : GRPCProtoCall?
//    
//    //date
//    let dateFormatter : DateFormatter = DateFormatter()
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        self.title = "Conversations"
//        self.tableView.separatorStyle = .singleLine
//        //register customcell into tableview
//        self.tableView.register(ChatListCustomCell.self, forCellReuseIdentifier: "ChatListCustomCell")
//        self.tableView.rowHeight = 100.0
//        //refresh control user interaction
//        //refresh.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
//        //add refreshControl into tableview
//        //self.tableView.addSubview(self.refresh)
//        //notification for new message in order to update UI(tableView)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatMessageNotification), name: NSNotification.Name(rawValue: "newMessageForChatListVC"), object: nil)
//        //set date format
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        //get conversations from the server
//        getConversations()
//    }
//    //set full size of view
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.tabBarController?.tabBar.isHidden = false
////        //get conversations from the server
////        getConversations()
//        if conversations.count != 0{
//            self.tableView.reloadData()
//        }
//    }
//    
//    //remove observer when view will disappear
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return conversations.count
//    }
//        
//    //display each component of each row of tableview
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCustomCell", for: indexPath) as! ChatListCustomCell
//        let row = indexPath.row
//        //self.log.debug("conversation:\(conversations.count)")
//        //cell.timeLabel.text = conversations[row].updated_at
//        cell.timeLabel.text = CustomizedObject.calculateElapsedTime(created: conversations[row].updated_at)
//        cell.idLabel.text = conversations[row].mentor_nickname
//        //update profile
//        cell.profile.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(conversations[row].mentor_profileurl)"),options:[.processor(processor)],completionHandler:{
//            (image, error, cacheType, imageUrl) in
//            if(image == nil){
//                cell.profile.image = UIImage(named: "defaultImage")
//            }else{
//                cell.profile.image = image
//            }
//        })
//        DispatchQueue.global(qos: .userInitiated).async {
//            let messagerealm = try! Realm()
//            //if the last message of the chat room(conversation), display unread signature
//            if let last = messagerealm.objects(Message.self).filter("conversation_id = %@",self.conversations[indexPath.row].conversation_id).last{
//                //안 읽었으면
//                if(last.is_read == "false"){
//                    DispatchQueue.main.async {
//                        cell.messageCounter.text = "🔴"
//                    }
//                }else{
//                    DispatchQueue.main.async {
//                        cell.messageCounter.text = ""
//                    }
//                }
//            }
//        }
//        loadLastMessage(label: cell.theLastTextLabel, conversation_id: conversations[row].conversation_id)
//        //others
//
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        /**
//         Cancel the image download task bounded to the image view if it is running.
//         Nothing will happen if the downloading has already finished.
//         */
//        cell.imageView?.kf.cancelDownloadTask()
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.isSelected = false
//        if conversations.count == 0{
//            return
//        }
//        //need to encode to store customized object into UserDefault
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: conversations[indexPath.row])
//        userDefault.set(encodedData, forKey: "conversation")
//        //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
//        userDefault.synchronize()
//        //join conversation
//        if CheckNetworkConnection.isConnectedToNetwork(){
//            let request  = JoinConversationRequest()
//            request.userId = Int64(userDefault.integer(forKey: "user_id"))
//            request.conversationId = Int64(conversations[indexPath.row].conversation_id)
//            joinConversation_protoCall = GRPC.sharedInstance.authorizedUser.rpcToJoinConversation(with: request, handler: {
//                (res,err) in
//                
//                if res != nil{
//                    self.joinConversation_protoCall?.finishWithError(nil)
//                    self.navigationController?.pushViewController(ChatViewController(), animated: true)
//                    return
//                }else{
//                    self.log.debug("Join Conversation Error:\(err)")
//                    self.joinConversation_protoCall?.finishWithError(err)
//                    if(err != nil){
//                        self.view.window?.makeToast("Failed to join chat", duration: 1.0, position: CSToastPositionBottom)
//                    }
//                }
//            })
//            joinConversation_protoCall?.timeout = App.timeout
//            joinConversation_protoCall?.start()
//        }else{
//            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
//        }
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    //delete
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let deleteRealmMessages = try! Realm()
//        if editingStyle == .delete{
//            let alertController = UIAlertController(title: "Caution", message: "Are you sure?", preferredStyle: .alert)
//            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in //confirm button clicked
//                if CheckNetworkConnection.isConnectedToNetwork(){
//                    let request = DeleteConversationRequest()
//                    request.conversationId = Int64(self.conversations[indexPath.row].conversation_id)
//                    request.userId = Int64(self.userDefault.integer(forKey: "user_id"))
//                    
//                    self.deleteConversation_protoCall = GRPC.sharedInstance.authorizedUser.rpcToDeleteConversation(with: request, handler: {
//                        (res,err) in
//                        
//                        if res != nil{
//                            self.deleteConversation_protoCall?.finishWithError(nil)
//                            //delete realm messages with conversation_id
//                            let messagesToDelete = deleteRealmMessages.objects(Message.self).filter("conversation_id = %@",self.conversations[indexPath.row].conversation_id)
//                            try! deleteRealmMessages.write {
//                                deleteRealmMessages.delete(messagesToDelete)
//                            }
//                            self.view.window?.makeToast("Successfully Deleted", duration: 1.0, position: CSToastPositionBottom)
//                            self.conversations.remove(at: indexPath.row)
//                            self.tableView.deleteRows(at: [indexPath], with: .fade)
//                        }else{
//                            
//                            self.log.debug("Delete Conversation error:\(err)")
//                            self.deleteConversation_protoCall?.finishWithError(err)
//                            if(err != nil){
//                                self.view.window?.makeToast("Delete Conversation Error", duration: 1.0, position: CSToastPositionBottom)
//                            }
//                        }
//                    })
//                    self.deleteConversation_protoCall?.timeout = App.timeout
//                    self.deleteConversation_protoCall?.start()
//                }else{
//                    self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
//                }
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//            alertController.addAction(deleteAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//    deinit{
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//
//
//extension ChatListViewController{
//    //helper function to get conversations of mine
//    func getConversations(){
//        log.debug()
//        if CheckNetworkConnection.isConnectedToNetwork(){
//            //need to remove all data of array to prevent duplicated
//            conversations.removeAll()
//            let realm = try! Realm()
//            let request = GetConversationsRequest()
//            request.userId = Int64((realm.objects(UserInfo.self).first?.user_id)!)
//            
//            
//            getConversation_protoCall = GRPC.sharedInstance.authorizedUser.rpcToGetConversations(with: request, handler: {
//                (res,err) in
//                
//                if res != nil{
//                    self.getConversation_protoCall?.finishWithError(nil)
//                    //database에 불러올 데이터가 없을때 -> 밑에 for 문 에러 방지
//                    //조건이 false인 경우에 else문 실행
//                    guard (res?.conversationsArray_Count) != 0 else{
//                        self.view.window?.makeToast("No Conversations yet", duration: 1.0, position: CSToastPositionBottom)
//                        self.log.debug("conversationsArray_Count is empty!")
//                        //self.tableView.reloadData()
//                        return
//                    }
//                    
//                    for i in 0..<Int((res?.conversationsArray_Count)!){
//                        let res = res?.conversationsArray.object(at: i) as! Conversation
//                        
//                        let conversation = ConversationObject(conversation_id:Int(res.conversationId),creator_id:Int(res.creatorId),user_nickname:res.userNickname,mentor_nickname:res.mentorNickname,mentor_profileurl:res.mentorProfileurl,mentor_user_id:Int(res.userId),updated_at:res.updatedAt)
//                        self.conversations.append(conversation)
//                    }
//                    self.tableView.reloadData()
//                }else{
//                    
//                    self.log.debug("Get Conversation Error:\(err)")
//                    self.getConversation_protoCall?.finishWithError(err)
//                    if(err != nil){
//                        self.view.window?.makeToast("Get Conversation Error", duration: 1.0, position: CSToastPositionBottom)
//                    }
//                }
//            })
//            getConversation_protoCall?.timeout = App.timeout
//            getConversation_protoCall?.start()
//        }else{
//            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
//        }
//    }
//    
//    //helper function to load the very last message of each conversations
//    func loadLastMessage(label:UILabel,conversation_id:Int){
//        
//        let messageRealm = try! Realm()
//        
//        if(messageRealm.objects(Message.self).filter("conversation_id == %@",conversation_id).count != 0){
//            //if there is messages with conversation_id
//            let messages = messageRealm.objects(Message.self).filter("conversation_id == %@",conversation_id)
//            self.log.debug("There is message with conversation_id: \(conversation_id) in Realm. Message: \(String(describing: messages.last?.message))")
//            if(messages.last?.message_type == "PHOTO"){
//                label.text = "PHOTO"
//            }else{
//                label.text = (messages.last?.message)!
//            }
//            
//        }else{
//            self.log.debug("There is no message with conversation_id: \(conversation_id) in Realm")
//            //there is no message with conversation_id
//            if CheckNetworkConnection.isConnectedToNetwork(){
//                let request = GetLastMessageRequest()
//                request.conversationId = Int64(conversation_id)
//                
//                GRPC.sharedInstance.authorizedUser.getLastMessage(with: request, handler: {
//                    (res,err) in
//                    
//                    if res != nil{
//                        DispatchQueue.main.async {
//                            label.text = (res?.message)!
//                        }
//                        //self.getLastMessage_protoCall?.finishWithError(nil)
//                    }else{
//                        
//                        label.text = "Error Occured!"
//                        self.log.debug("Get Last Message Error:\(err)")
//                        //self.getLastMessage_protoCall?.finishWithError(err)
//                        if(err != nil){
//                            self.view.window?.makeToast("Get Last Message Error", duration: 1.0, position: CSToastPositionBottom)
//                        }
//                    }
//                })
//                //getLastMessage_protoCall?.timeout = App.timeout
//                //getLastMessage_protoCall?.start()
//            }else{
//                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
//            }
//        }
//        
//    }
//    
//    //refreshControl method
//    //need to call server to get refresh recently created data when user scroll down tableView
////    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
////        //refresh method here
////        getConversations()
////        refresh.endRefreshing()
////    }
//}
//
//extension ChatListViewController{
//    @objc func handleNewChatMessageNotification(notification: NSNotification){
//        //this method is running on the background thread because this is called on background thread of app delegate push notification received
//        //let messageObject = notification.object as! [String: Any]
//        //self.log.debug(messageObject)
//        
////        let message_id = messageObject["message_id"] as? Int?
////        let conversation_id = messageObject["conversation_id"] as? Int?
////        let sender_id = messageObject["sender_id"] as? Int?
////        let sender_name = messageObject["sender_name"] as? String?
////        let message_type = messageObject["message_type"] as? String?
////        let message = messageObject["message"] as? String?
////        let created_at = messageObject["created_at"] as? String?
//        
//        let messageObject = notification.object as! [String: Any]
//        log.debug("messageObject")
//        let conversation_id = messageObject["conversation_id"] as? Int?
//        let created_at = messageObject["created_at"] as! String
//        if(self.conversations.contains{$0.conversation_id == conversation_id}){
//            
//            let index = self.conversations.index{$0.conversation_id == conversation_id}
//            let conversation = self.conversations[index!]
//            //update conversation
//            conversation.updated_at = created_at
//            self.conversations.remove(at:index!)
//            //self.log.debug(conversations.count)
//            self.conversations.insert(conversation, at: 0)
//            //self.log.debug(conversations.count)
//            self.tableView.reloadData()
//            
//        }else{//false
//            self.getConversations()
//        }
//    }
//}
