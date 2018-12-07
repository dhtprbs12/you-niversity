///*
// MIT License
// 
// Copyright (c) 2017-2018 MessageKit
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// */
//
//import Foundation
//import UIKit
//import MessageKit
//import MapKit
//import Material
//import XCGLogger
//import RealmSwift
//import Photos
//import Kingfisher
//import SwiftGifOrigin
//import RxSwift
//import RxCocoa
//
////only text message is available, not photo, video and etc.
////will fix later too complicated now
//
//class ChatViewController: MessagesViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    //variables for the view
//    var leftViewWidth = .phone == Device.userInterfaceIdiom ? 280 : 320
//    let refreshControl = UIRefreshControl()
//    var messageList: [MockMessage] = []
//    var library : InputBarButtonItem!
//    //others
//    let log = XCGLogger.default
//    var img : UIImage!
//    var object : ConversationObject?
//    var request : SendMessageRequest!
//    var imageURL = String()
//    var haveImage : Bool = false
//    let userDefault = UserDefaults.standard
//    
//    var leaveConversation_protocall: GRPCProtoCall?
//    var getMessages_protocall: GRPCProtoCall?
//    var getMoreMessages_protocall: GRPCProtoCall?
//    var sendMessage_protocall: GRPCProtoCall?
//    var chatStream_protocall: GRPCProtoCall?
//
//    lazy var formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter
//    }()
//
//    //date
//    let dateFormatter : DateFormatter = DateFormatter()
//    var date : Date!
//    var dateString = String()
//    //image
//    var imagePicker = UIImagePickerController()
//    var imagetapGestureRecognizer : UITapGestureRecognizer!
//    var mockMessageImage = UIImage()
//    
//    let gif = UIImage.gif(name: "loader")
//    let failToLoad = UIImage(named:"baseline_replay_black_24pt")
//    let processor = RoundCornerImageProcessor(cornerRadius: 20)
//    //var timer: Timer!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //init conversation info from chatList
//        loadConversationInfo()
//        //init Messages in this conversation
//        initMessages()
//        //set date format
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        //delegate set
//        self.messagesCollectionView.messagesDataSource = self
//        self.messagesCollectionView.messagesLayoutDelegate = self
//        self.messagesCollectionView.messagesDisplayDelegate = self
//        self.messagesCollectionView.messageCellDelegate = self
//        self.messageInputBar.delegate = self
//        //image button
//        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        scrollsToBottomOnKeybordBeginsEditing = true // default false
//        maintainPositionOnKeyboardFrameChanged = true // default false
//        //library = makeButton(named: "ic_library")
//        //library.contentEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 2, right: 2)
//        
//        //if user taps imageView, invoked
//        imagetapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(sender:)))
//        //library.addGestureRecognizer(imagetapGestureRecognizer)
//        //library.tintColor = UIColor.lightGray
//        //init the view
//        iMessage()
//        //read all msg as true
//        readAllMsgTrue()
//        //observeMessage
//        getMessage()
//        //set refresh control to load more messages when user scrolls up
//        messagesCollectionView.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(ChatViewController.loadMoreMessages), for: .valueChanged)
//        
//        //imagePicker 도 역시 imagePicker를 쓰는 뷰컨트롤러에 delegate를 선언해줘야 imagePicker의 메소드들을 self(뷰컨트롤러)에서 사용 가능
//        imagePicker.delegate = self
//        userDefault.set((object?.conversation_id)!, forKey: "conversation_id")
//    }
//    
//    //set full size of view
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.tabBarController?.tabBar.isHidden = true
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        //check if there is unread message in main tabbar
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "checkIfThereIsUnreadMessages"), object: nil)
//        //when back button tapped
//        if (self.isMovingFromParentViewController) {
//            //getMessages_protocall?.finishWithError(nil)
//            //getMoreMessages_protocall?.finishWithError(nil)
//        
//            sendMessage_protocall?.finishWithError(nil)
//            chatStream_protocall?.finishWithError(nil)
//            
//            let leave_request = LeaveConversationRequest()
//            leave_request.userId = Int64(userDefault.integer(forKey: "user_id"))
//            leave_request.conversationId = Int64((object?.conversation_id)!)
//            if CheckNetworkConnection.isConnectedToNetwork(){
//                leaveConversation_protocall = GRPC.sharedInstance.authorizedUser.rpcToLeaveConversation(with:leave_request, handler: {
//                    (res,err) in
//                    
//                    if res != nil{
//                        self.log.debug()
//                        self.leaveConversation_protocall?.finishWithError(nil)
//                    }else{
//                        self.log.debug("Leave conversation error: \(err)")
//                        self.leaveConversation_protocall?.finishWithError(err)
//                        if(err != nil){
//                            self.view.window?.makeToast("Leave conversation error", duration: 1.0, position: CSToastPositionBottom)
//                        }
//                    }
//                })
//                leaveConversation_protocall?.timeout = App.timeout
//                leaveConversation_protocall?.start()
//            }else{
//                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
//            }
//        }
//        
////                ImageObjects.cache.clearMemoryCache()
////                ImageObjects.cache.clearDiskCache()
////                ImageObjects.cache.cleanExpiredDiskCache()
//    }
//    
//    //load conversation info
//    func loadConversationInfo(){
//        let decoded  = userDefault.object(forKey: "conversation") as! Data
//        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? ConversationObject
//        //set title as receiver name
//        if(object?.mentor_nickname.isEmpty)!{
//            self.title = object?.user_nickname
//        }else{
//            self.title = object?.mentor_nickname
//        }
//        
//    }
//    
//    //init Message called in viewDidLoad()
//    func initMessages(){
//        DispatchQueue.global(qos: .userInitiated).async {
//            let get_messages_from_realm = try! Realm()
//            //var messages: [MockMessage] = []
//            
//            if (get_messages_from_realm.objects(Message.self).filter("conversation_id == %@",(self.object?.conversation_id)!).count != 0){
//                let messages_from_realm = get_messages_from_realm.objects(Message.self).filter("conversation_id == %@",(self.object?.conversation_id)!).sorted(byKeyPath: "message_id",ascending: true) //get message ascening:1,2,3,..,count
//                //check if realm data.count is greater than "number"
//                if(messages_from_realm.count >= 10){
//                    //var init_index = 0
//                    for i in stride(from: messages_from_realm.count-10, through: messages_from_realm.count-1, by: 1){
//                        
////                        if(init_index == 10){
////                            break
////                        }
//                        
//                        let senderObj = Sender(id:"\(messages_from_realm[i].sender_id)",displayName:messages_from_realm[i].sender_name)
//                        
//                        let messageObject = MockMessage(text:messages_from_realm[i].message,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
//                        self.messageList.append(messageObject)
//                        
////                        //if "TEXT"
////                        if(messages_from_realm[i].message_type == "TEXT"){
////                            let messageObject = MockMessage(text:messages_from_realm[i].message,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
////                            self.messageList.append(messageObject)
////                        }else{
////                            //if "PHOTO"
////                            let messageObject = MockMessage(image:self.gif!,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
////                            self.messageList.append(messageObject)
////                            self.setMessageData(data: messages_from_realm[i].message, messageType: messages_from_realm[i].message_type, messageIndex: self.messageList.count - 1)
////                        }
//                        //check if it is first message stored in realm,break for loop
////                        if(messages_from_realm[i].message_id == messages_from_realm.first?.conversation_id){
////                            break
////                        }
////                        init_index = init_index + 1
//                    }
//                    DispatchQueue.main.async {
//                        self.messagesCollectionView.reloadData()
//                        self.messagesCollectionView.scrollToBottom()
//                    }
//                }else{
//                    
//                    for i in stride(from: 0, through: messages_from_realm.count-1, by: 1){
//                        let senderObj = Sender(id:"\(messages_from_realm[i].sender_id)",displayName:messages_from_realm[i].sender_name)
//                        
//                        let messageObject = MockMessage(text:messages_from_realm[i].message,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
//                        self.messageList.append(messageObject)
//                        
////                        //if "TEXT"
////                        if(messages_from_realm[i].message_type == "TEXT"){
////                            let messageObject = MockMessage(text:messages_from_realm[i].message,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
////                            self.messageList.append(messageObject)
////                        }else{
////                            //if "PHOTO"
////                            let messageObject = MockMessage(image:self.gif!,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
////                            self.messageList.append(messageObject)
////                            self.setMessageData(data: messages_from_realm[i].message, messageType: messages_from_realm[i].message_type, messageIndex: self.messageList.count - 1)
////                        }
//                    }
//                    DispatchQueue.main.async {
//                        self.messagesCollectionView.reloadData()
//                        self.messagesCollectionView.scrollToBottom()
//                    }
//                }//end of messages_from_realm.count >= 10
//            }
//        }
//    }
//    
//    @objc func loadMoreMessages() {
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            //loadmore
//            let more_message_realm = try! Realm()
//            //var messages: [MockMessage] = []
//            
//            let messages_from_realm = more_message_realm.objects(Message.self).filter("conversation_id == %@",(self.object?.conversation_id)!).sorted(byKeyPath: "message_id",ascending: true) //get message ascening 1,2,3,..,count
//            
//            let more_messages = messages_from_realm.filter("message_id < \(self.messageList[0].messageId)")
//            
//            //executed if there are previous messages
//            if(more_messages.count != 0){
//                
//                var more_index = 0
//                
//                for i in stride(from: (more_messages.count)-1, through: 0, by: -1){
//                    
//                    if(more_index == 10){
//                        
//                        break
//                    }
//                    
//                    let senderObj = Sender(id:"\(more_messages[i].sender_id)",displayName:more_messages[i].sender_name)
//                    
//                    let messageObject = MockMessage(text:more_messages[i].message,sender:senderObj,messageId:"\(more_messages[i].message_id)",date:more_messages[i].created_at!)
//                    self.messageList.insert(messageObject,at:0)
//                    
////                    //if "TEXT"
////                    if(more_messages[i].message_type == "TEXT"){
////                        let messageObject = MockMessage(text:more_messages[i].message,sender:senderObj,messageId:"\(more_messages[i].message_id)",date:more_messages[i].created_at!)
////                        self.messageList.insert(messageObject,at:0)
////                    }else{
////                        //if "PHOTO"
////                        let messageObject = MockMessage(image:self.gif!,sender:senderObj,messageId:"\(more_messages[i].message_id)",date:more_messages[i].created_at!)
////                        self.messageList.insert(messageObject,at:0)
////                        self.setMessageData(data: more_messages[i].message, messageType: more_messages[i].message_type, messageIndex: 0)
////                    }
//                    //check if it is first message stored in realm,break for loop
//                    if(more_messages[i].message_id == more_messages.first?.message_id){
//                        //self.log.debug("ya:\(more_messages[i].message_id)")
//                        break
//                    }
//                    more_index = more_index + 1
//                }//end of for loop
//                
//                DispatchQueue.main.async {
//                    //self.messageList.insert(contentsOf: messages.reversed(), at: 0)
//                    self.messagesCollectionView.reloadDataAndKeepOffset()
//                    self.refreshControl.endRefreshing()
//                }
//            }else{//if there is no previous message
//                DispatchQueue.main.async {
//                    //self.messageList.insert(contentsOf: messages.reversed(), at: 0)
//                    self.messagesCollectionView.reloadDataAndKeepOffset()
//                    self.refreshControl.endRefreshing()
//                }
//            }
//        }
//    }
//    
//    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: { () -> Void in })
//    }
//    
//    //when user clicks image
//    @objc func imageTapped(sender: UITapGestureRecognizer){
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        //must set this property to dismiss only pickerVC
//        imagePicker.modalPresentationStyle = .overCurrentContext
//        self.present(imagePicker, animated: true, completion:nil)
//    }
//    
//    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        picker.dismiss(animated: true, completion: nil)
//        var data : Data?
//        var resizedImg : UIImage?
//        let URL = info[UIImagePickerControllerReferenceURL] as! NSURL
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        //set dateFormat from date to string
//        date = Date()
//        dateString = dateFormatter.string(from: date)
//        imageURL = "\(userDefault.integer(forKey: "user_id"))-\((URL.absoluteURL?.query)!).jpeg"
//        //imageURL = "\(currentSender().id)-\(dateString).jpeg"
//        //can't send the image if not resize it because it is too big
//        if(image.size.width >= 500.0 || image.size.height >= 500.0){
//            resizedImg = image.resizeImage(image: image, newWidth: 300.0)
//            data = resizedImg?.highestQualityJPEGNSData
//            //data = UIImageJPEGRepresentation(resizedImg!,1)
//        }else{
//            data = image.highestQualityJPEGNSData
//            //data = UIImageJPEGRepresentation(image,1)
//        }
//        
//        //data = image.lowQualityJPEGNSData
//        
//        //store into Kingfisher cache memory
//        ImageObjects.cache.store(UIImage(data:data!)!, forKey: imageURL)
//        //set mockMessageImage to store into messageList
//        mockMessageImage = image
//        //send message to the server
//        request = SendMessageRequest()
//        request.conversationId = Int64((object?.conversation_id)!)
//        request.senderId = Int64(currentSender().id)!
//        request.receiverId = Int64((object?.mentor_user_id)!)
//        request.senderName = currentSender().displayName
//        //when it is photo just set request.message by image url
//        request.message = imageURL
//        request.messageType = "PHOTO"
//        request.createdAt = dateString
//        request.imageData = data
//        //does not need to initiate text & inputBar when sending a image to the server
//        self.sendMessage(request: request,text:nil,inputBar: nil)
//        
//    }
//    
//    //for Text and Photo which is just type not real image
//    func sendMessage(request:SendMessageRequest,text:NSAttributedString?,inputBar: MessageInputBar?){
//        
//        if CheckNetworkConnection.isConnectedToNetwork(){
//            GRPC.sharedInstance.authorizedUser.sendMessage(with: request, handler: {
//                (res,err) in
//                if res != nil{
//                    //self.sendMessage_protocall?.finishWithError(nil)
//                    self.saveMessageIntoRealm(msg: (res?.message)!)
//                    
//                    let message = MockMessage(attributedText: text!, sender: self.currentSender(), messageId: String((res?.message.messageId)!),date:self.dateFormatter.date(from: (res?.message.createdAt)!)!)
//                    self.messageList.append(message)
//                    //update UI
//                    self.messagesCollectionView.insertSections([self.messageList.count - 1])
//                    
////                    //insert message into messageList
////                    if(request.messageType == "TEXT"){
////
////                        let message = MockMessage(attributedText: text!, sender: self.currentSender(), messageId: String((res?.message.messageId)!),date:self.dateFormatter.date(from: (res?.message.createdAt)!)!)
////                        self.messageList.append(message)
////                        //update UI
////                        self.messagesCollectionView.insertSections([self.messageList.count - 1])
////                    }else{//"PHOTO"
////                        self.log.debug()
////                        let imageMessage = MockMessage(image: self.mockMessageImage, sender: self.currentSender(), messageId: String((res?.message.messageId)!),date:self.dateFormatter.date(from: (res?.message.createdAt)!)!)
////                        self.messageList.append(imageMessage)
////                        //update UI
////                        self.messagesCollectionView.insertSections([self.messageList.count - 1])
////                    }
//                    inputBar?.inputTextView.text = String()
//                    self.messagesCollectionView.scrollToBottom()
//                }else{
//                    
//                    
//                    self.log.debug("Send Message Error:\(err)")
//                    //self.sendMessage_protocall?.finishWithError(err)
//                    if(err != nil){
//                        self.view.window?.makeToast("Send Message Error", duration: 1.0, position: CSToastPositionBottom)
//                    }
//                }
//            })
//            //sendMessage_protocall?.timeout = App.timeout
//            //sendMessage_protocall?.start()
//        }else{
//            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
//        }
//    }
//    
//    func setMessageData(data: String, messageType: String, messageIndex: Int) -> Void{
//        //if message_type is "PHOTO"
//        if messageType.range(of:"PHOTO") != nil {
//            
//            ImageObjects.cache.retrieveImage(forKey: data, options: nil, completionHandler: {
//                (image,CacheType) in
//                if (image != nil) {
//                    self.log.debug("Image in Cache: \(data) - \(messageIndex)")
//                    self.reloadMessage(messageIndex, image!)
//                    
//                    
//                }else{
//                    self.log.debug("Image in Server: \(data) - \(messageIndex)")
////                    let imageView = ImageView()
////                    imageView.kf.indicatorType = .activity
////                    imageView.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(data)")!,options: [.transition(.fade(0.2))], completionHandler: {
////                        (image, error, cacheType, imageUrl) in
////                        if (image != nil) {
////                            self.reloadMessage(messageIndex, image!)
////                            ImageObjects.cache.store(image!, forKey:data)
////                        }else{
////                            //if fail to download image,need to fix here
////                            self.reloadMessage(messageIndex, self.gif!)
////                        }
////                    })
//
//                    //but, ImageDownloader.default.downloadImage doesnt store image into cache
//                        ImageDownloader.default.downloadImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(data)")!, options: [], progressBlock: nil) {
//                            (image, error, url, imageURL) in
//                            if image == nil{
//                                //fail to load
//                                self.log.debug()
//                                self.reloadMessage(messageIndex, self.gif!)
//                            }else{
//                                //update ui
//                                self.log.debug()
//                                self.reloadMessage(messageIndex, image!)
//                                ImageObjects.cache.store(image!, forKey:data)
//                            }
//                        }
//                }
//            })
//        }
//    }
//    
//    
//    func reloadMessage(_ messageIndex: Int,_ image :UIImage) -> Void {
//        
//        if messageIndex < self.messageList.count {
//            let oldMessage = self.messageList[messageIndex]
//            
//            self.messageList[messageIndex] = MockMessage(
//                image: image,
//                sender: oldMessage.sender,
//                messageId: oldMessage.messageId,
//                date:oldMessage.sentDate
//            )
//            
//            
//            
//            if messageIndex == 0{ //refreshing
//                self.messagesCollectionView.reloadDataAndKeepOffset()
//                self.refreshControl.endRefreshing()
//            }else{
//                self.messagesCollectionView.reloadData()
//                //self.messagesCollectionView.scrollToBottom()
//            }
//            
//        }
//    }
//    
//    //observer there is new message
//    //both sender and receiver in the same room
//    func getMessage(){
//        
//        if CheckNetworkConnection.isConnectedToNetwork(){
//            //As you will see, all these methods are asynchronous, so you can call them from the main thread
//            let request = ChatStreamRequest()
//            request.conversationId = Int64((object?.conversation_id)!)
//            request.receiverId = Int64(userDefault.integer(forKey: "user_id"))
//
//             GRPC.sharedInstance.authorizedUser.chatStream(with: request, eventHandler: {
//                (bool,res,err)  in
//
//                if res != nil{
//                    self.log.debug()
//                    let obj = res?.messagesArray as! [MessageObject]
//                    for i in 0..<obj.count{
//                        let msg = obj[i]
//                        //self.log.debug("MessageObject1:\(msg)")
//                        let senderObj = Sender(id:"\(msg.messageId)",displayName:msg.senderName)
//                        
//                        let messageObject = MockMessage(text: msg.message, sender: senderObj, messageId: "\(msg.messageId)",date:self.dateFormatter.date(from: msg.createdAt)!)
//                        
//                        self.messageList.append(messageObject)
////
////                        if(msg.messageType == "TEXT"){
////                            let messageObject = MockMessage(text: msg.message, sender: senderObj, messageId: "\(msg.messageId)",date:self.dateFormatter.date(from: msg.createdAt)!)
////
////                            self.messageList.append(messageObject)
////
////
////                        }else{
////
////                            let messageObject = MockMessage(image:self.gif!,sender:senderObj,messageId:"\((msg.messageId))",date:self.dateFormatter.date(from: msg.createdAt)!)
////
////                            self.messageList.append(messageObject)
////                            self.setMessageData(data: (msg.message), messageType: (msg.messageType), messageIndex: self.messageList.count - 1)
////
////                        }
//
//                        self.saveMessageIntoRealm(msg: msg)
//                    }
//                    self.messagesCollectionView.reloadData()
//                    self.messagesCollectionView.scrollToBottom()
//                    
//                }else{
//                    self.log.debug("Get Message Error:\(err)")
//                    if(err != nil){
//                        self.view.window?.makeToast("Get Message Error", duration: 1.0, position: CSToastPositionBottom)
//                    }
//                }
//            })
//            //chatStream_protocall?.timeout = 10
//            //chatStream_protocall?.start()
//        }else{
//            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
//        }
//
//    }
//    
//    func saveMessageIntoRealm(msg:MessageObject){
//        DispatchQueue.global(qos: .background).async {
//            let observeRealm = try! Realm()
//            //let conversation = observeRealm.objects(Conversation.self).filter("conversation_id == \((self.object?.conversation_id)!)")
//            try! observeRealm.write {
//                let message = Message()
//                message.message_id = Int(msg.messageId)
//                message.conversation_id = Int(msg.conversationId)
//                message.sender_id = Int(msg.senderId)
//                message.receiver_id = Int(msg.receiverId)
//                message.sender_name = msg.senderName
//                message.message_type = msg.messageType
//                message.message = msg.message
//                message.created_at = self.dateFormatter.date(from: msg.createdAt)
//                message.is_read = "true"
//                //self.log.debug("saveMessageIntoRealm:\(message)")
//                observeRealm.create(Message.self, value: message, update: false)
//            }
//        }
//    }
//
//    func readAllMsgTrue(){
//        DispatchQueue.global(qos: .background).async {
//            let readMsgTrueRealm = try! Realm()
//            let messages = readMsgTrueRealm.objects(Message.self).filter("conversation_id == %@",(self.object?.conversation_id)!)
//            let unread_messages = messages.filter("is_read == %@","false")
//            //check if there are unread messages
//            if unread_messages.count != 0{
//                //there are unread messages in the conversation
//                try! readMsgTrueRealm.write{
//                    for message in unread_messages{
//                        readMsgTrueRealm.create(Message.self, value: ["message_id": message.message_id, "is_read": "true"], update: true)
//                    }
//                }
//            }else{
//                //do nothing
//            }
//        }
//    }
//}
//
//extension ChatViewController: MessageInputBarDelegate {
//    //this is only called when user type some text and hit the submit button
//    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
//        log.debug()
//        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
//        date = Date()
//        
//        dateString = dateFormatter.string(from: date)
//        
//        for component in inputBar.inputTextView.components {
//            if let text = component as? String {
//                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
//                
//                //                let message = MockMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: date)
//                //                messageList.append(message)
//                //                messagesCollectionView.insertSections([messageList.count - 1])
//                //send message to the server
//                request = SendMessageRequest()
//                request.conversationId = Int64((object?.conversation_id)!)
//                request.senderId = Int64(currentSender().id)!
//                request.receiverId = Int64((object?.mentor_user_id)!)
//                request.senderName = currentSender().displayName
//                request.message = text.trimmed
//                request.messageType = "TEXT"
//                request.createdAt = dateString
//                //request.imageData = "" //doesn't need to initialized this value when its text
//                self.sendMessage(request: request,text:attributedText,inputBar: inputBar)
//            }
//        }
////        inputBar.inputTextView.text = String()
////        messagesCollectionView.scrollToBottom()
//    }
//}
//
//// MARK: - MessagesDataSource
//
//extension ChatViewController: MessagesDataSource {
//
//    func currentSender() -> Sender {
//        //return SampleData.shared.currentSender
//        let realm = try! Realm()
//        var senderName = ""
//        if let mentor = realm.objects(MentorInfo.self).first{
//            //if I've registered as a mentor, set sender_name as a mentor_nickname
//            senderName = mentor.mentor_nickname
//        }else{
//            //if I've not registered as a mentor, use my user nickname as a sender_name
//            senderName = (realm.objects(UserInfo.self).first?.nickname)!
//        }
//        return Sender(id:"\((realm.objects(UserInfo.self).first?.user_id)!)",displayName:senderName)
//    }
//    
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return messageList.count
//    }
//    
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        return messageList[indexPath.section]
//    }
//    
//    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if indexPath.section % 3 == 0 {
//            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
//        }
//        return nil
//    }
//    
//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sender.displayName
//        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
//    }
//    
//    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        
//        let dateString = formatter.string(from: message.sentDate)
//        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
//    }
//    
//}
//
//// MARK: - MessagesDisplayDelegate
//
//extension ChatViewController: MessagesDisplayDelegate {
//    
//    // MARK: - Text Messages
//    
//    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .white : .darkText
//    }
//    
//    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey : Any] {
//        return MessageLabel.defaultAttributes
//    }
//    
//    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
//        return [.url, .address, .phoneNumber, .date]
//    }
//    
//    // MARK: - All Messages
//    
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
//    }
//    
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .curved)
//        //        let configurationClosure = { (view: MessageContainerView) in}
//        //        return .custom(configurationClosure)
//    }
//    
//    
//
//    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//                //let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
//                //avatarView.set(avatar: avatar)
//        //avatarView.set(avatar: Avatar(image:UIImage(named:"defaultImage")))
//        if message.sender.id == "\(userDefault.integer(forKey: "user_id"))"{
//            //me
//            let myselfRealm = try! Realm()
//            if let mentor = myselfRealm.objects(MentorInfo.self).first{
//                //Kingfisher will download the image from url, send it to both the memory cache and the disk cache, and display it in imageView. When you use the same code later, the image will be retrieved from cache and shown immediately.
//                avatarView.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(mentor.mentor_profile_url)"),options:[.processor(processor)],completionHandler:{
//                    (image, error, cacheType, imageUrl) in
//                    //if fails image == nil
//                    if(image == nil){
//                        avatarView.image = UIImage(named: "defaultImage")
//                    }else{
//                        avatarView.image = image
//                    }
//                })
//            }else{
//                avatarView.image = UIImage(named: "defaultImage")
//            }
//        }else{
//            //other
//            if(object?.mentor_profileurl.isEmpty)!{
//                avatarView.image = UIImage(named: "defaultImage")
//            }else{
//                avatarView.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\((object?.mentor_profileurl)!)"),options:[.processor(processor)],completionHandler:{
//                    (image, error, cacheType, imageUrl) in
//                    //if fails image == nil
//                    if(image == nil){
//                        avatarView.image = UIImage(named: "defaultImage")
//                    }else{
//                        avatarView.image = image
//                    }
//                })
//            }
//        }
//    }
//    
//    // MARK: - Location Messages
//    
//    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
//        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
//        let pinImage = #imageLiteral(resourceName: "pin")
//        annotationView.image = pinImage
//        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
//        return annotationView
//    }
//    
//    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
//        return { view in
//            view.layer.transform = CATransform3DMakeScale(0, 0, 0)
//            view.alpha = 0.0
//            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
//                view.layer.transform = CATransform3DIdentity
//                view.alpha = 1.0
//            }, completion: nil)
//        }
//    }
//    
//    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
//        
//        return LocationMessageSnapshotOptions()
//    }
//}
//
//// MARK: - MessagesLayoutDelegate
//
//// MARK: - MessagesLayoutDelegate
//
//extension ChatViewController: MessagesLayoutDelegate {
//    
//    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        if indexPath.section % 3 == 0 {
//            return 10
//        }
//        return 0
//    }
//    
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 16
//    }
//    
//    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 16
//    }
//    
//}
//
//// MARK: - MessageCellDelegate
//
//extension ChatViewController: MessageCellDelegate {
//    
//    func didTapAvatar(in cell: MessageCollectionViewCell) {
//        print("Avatar tapped")
//    }
//    
//    func didTapMessage(in cell: MessageCollectionViewCell) {
//        print("Message tapped")
//    }
//    
//    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
//        print("Top cell label tapped")
//    }
//    
//    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
//        print("Top message label tapped")
//    }
//    
//    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
//        print("Bottom label tapped")
//    }
//    
//}
//
//// MARK: - MessageLabelDelegate
//
//extension ChatViewController: MessageLabelDelegate {
//    
//    func didSelectAddress(_ addressComponents: [String: String]) {
//        print("Address Selected: \(addressComponents)")
//    }
//    
//    func didSelectDate(_ date: Date) {
//        print("Date Selected: \(date)")
//    }
//    
//    func didSelectPhoneNumber(_ phoneNumber: String) {
//        print("Phone Number Selected: \(phoneNumber)")
//    }
//    
//    func didSelectURL(_ url: URL) {
//        print("URL Selected: \(url)")
//    }
//    
//    func didSelectTransitInformation(_ transitInformation: [String: String]) {
//        print("TransitInformation Selected: \(transitInformation)")
//    }
//    
//}
//
//extension ChatViewController{
//    //default setting for chat's view
//    
//    func getMessagesFromRealm(count: Int,type:String, completion: ([MockMessage]) -> Void){
//        
//        let get_messages_from_realm = try! Realm()
//        var messages: [MockMessage] = []
//        
//        if (get_messages_from_realm.objects(Message.self).filter("conversation_id == %@",(self.object?.conversation_id)!).count != 0){
//            let messages_from_realm = get_messages_from_realm.objects(Message.self).filter("conversation_id == %@",(self.object?.conversation_id)!).sorted(byKeyPath: "message_id",ascending: true) //get message ascening:1,2,3,..,count
//            
//            
//            if(type == "init"){
//                
//                var init_index = 0
//            
//                for i in stride(from: messages_from_realm.count-1, through: 0, by: -1){
//                    
//                    if(init_index == count){
//                        break
//                    }
//                    
//                    let senderObj = Sender(id:"\(messages_from_realm[i].sender_id)",displayName:messages_from_realm[i].sender_name)
//                    //if "TEXT"
//                    if(messages_from_realm[i].message_type == "TEXT"){
//                        let messageObject = MockMessage(text:messages_from_realm[i].message,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
//                        messages.append(messageObject)
//                    }else{
//                        //if "PHOTO"
//                        let messageObject = MockMessage(image:self.gif!,sender:senderObj,messageId:"\(messages_from_realm[i].message_id)",date:messages_from_realm[i].created_at!)
//                        messages.append(messageObject)
////                        self.setMessageData(data: messages_from_realm[i].message, messageType: messages_from_realm[i].message_type, messageIndex: messages.count - 1)
//                    }
//                    //check if it is first message stored in realm,break for loop
//                    if(messages_from_realm[i].message_id == messages_from_realm.first?.conversation_id){
//                        break
//                    }
//                    init_index = init_index + 1
//                }
//            }else{
//                
//            }
//        }
//        completion(messages.reversed())
//    }
//    
//    func iMessage() {
//        defaultStyle()
//        messageInputBar.isTranslucent = false
//        messageInputBar.backgroundView.backgroundColor = .white
//        messageInputBar.separatorLine.isHidden = true
//        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
//        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 36)
//        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 36)
//        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
//        messageInputBar.inputTextView.layer.borderWidth = 1.0
//        messageInputBar.inputTextView.layer.cornerRadius = 16.0
//        messageInputBar.inputTextView.layer.masksToBounds = true
//        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
//        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
//        
//        //messageInputBar.setLeftStackViewWidthConstant(to: 32, animated: false)
//        //messageInputBar.setStackViewItems([library], forStack: .left, animated: false)
//        //messageInputBar.leftStackViewItems[0].addGestureRecognizer(imagetapGestureRecognizer)
//        
//        messageInputBar.sendButton.imageView?.backgroundColor = App.mainColor
//        //messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
//        messageInputBar.sendButton.image = #imageLiteral(resourceName: "ic_up")
//        messageInputBar.sendButton.title = nil
//        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
//        messageInputBar.sendButton.backgroundColor = .clear
//        messageInputBar.textViewPadding.right = -38
//        messageInputBar.textViewPadding.left = 10
//    }
//    
//    func defaultStyle() {
//        let newMessageInputBar = MessageInputBar()
//        newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//        newMessageInputBar.delegate = self
//        messageInputBar = newMessageInputBar
//        reloadInputViews()
//    }
//    
//    // MARK: - Helpers
//    func makeButton(named: String) -> InputBarButtonItem {
//        return InputBarButtonItem()
//            .configure {
//                $0.spacing = .fixed(10)
//                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
//                $0.setSize(CGSize(width: 30, height: 30), animated: true)
//            }.onSelected {
//                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
//            }.onDeselected {
//                $0.tintColor = UIColor.lightGray
//            }.onTouchUpInside { _ in
//                print("Item Tapped")
//        }
//    }
//}
