//
//  MentorCommentReplyTableViewController.swift
//  MyUniversity
//
//  Created by 오세균 on 8/21/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import XCGLogger
import Then
import SnapKit
import Material
import PKHUD

//Int this VC, MentorCommentObject.comment_id is replied_comment_id of reply_mentor_comment database

class MentorCommentReplyTableViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    var mentorCommentReplyTableView: MentorCommentReplyTableView{
        return self.view as! MentorCommentReplyTableView
    }
    var object : MentorCommentObject?
    let log = XCGLogger.default
    var uploadCommentBtn: RaisedButton!
    var textField : UITextField!
    var userDefault = UserDefaults.standard
    var commentList = [MentorCommentObject]()
    
    var getComment_protoCall : GRPCProtoCall?
    var uploadComment_protoCall : GRPCProtoCall?
    
    override func loadView() {
        super.loadView()
        self.view = MentorCommentReplyTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        mentorCommentReplyTableView.tableView.delegate = self
        mentorCommentReplyTableView.tableView.dataSource = self
        mentorCommentReplyTableView.tableView.keyboardDismissMode = .interactive
        mentorCommentReplyTableView.tableView.separatorStyle = .none
        mentorCommentReplyTableView.tableView.separatorColor = UIColor.clear
        mentorCommentReplyTableView.tableView.rowHeight = UITableViewAutomaticDimension
        mentorCommentReplyTableView.tableView.estimatedRowHeight = 100.0
        mentorCommentReplyTableView.tableView.register(MentorCommentTableViewCell.self, forCellReuseIdentifier: "MentorCommentTableViewCell")
        mentorCommentReplyTableView.tableView.register(MentorCommentReplyTableViewCell.self, forCellReuseIdentifier: "MentorCommentReplyTableViewCell")
        //set textfield
        textField = UITextField().then{
            $0.placeholder = "Comment here..."
            $0.borderWidthPreset = .border1
            $0.layer.cornerRadius = 3
            $0.returnKeyType = .done
            $0.autocorrectionType = UITextAutocorrectionType.no
        }
        self.view.addSubview(textField)
        textField.snp.makeConstraints{
            $0.width.equalTo(self.view.frame.width)
            $0.height.equalTo(30)
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        textField.delegate = self
        uploadCommentBtn = RaisedButton(type: .system).then{
            $0.frame.size = CGSize(width:60,height:30)
            $0.setTitle("send", for: .normal)
            $0.isMultipleTouchEnabled = false
            //$0.backgroundColor = App.mainColor
            $0.setTitleColor(App.mainColor, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            //$0.layer.cornerRadius = 2
        }
        uploadCommentBtn.rx.tap.subscribe(onNext: { [weak self] x in
            self?.uploadCommentBtnTapped()
        }).disposed(by: App.disposeBag)
        textField.rightViewMode = .always
        textField.rightView = uploadCommentBtn
        
        
        let decoded  = userDefault.object(forKey: "mentor_comment") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? MentorCommentObject
        //load replied comments on this comment
        commentList.removeAll()
        loadRepliedMentorComments(replied_comment_id:0,comment_id: Int64((object?.comment_id)!),scroll_is: "init")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        //when keyboard is up and user goes back to CommentTableVC
        textField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //키보드 보여질때와 없어질때 실행되는 notification을 탐지해서 그에 해당하는 메소드를 실행
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = mentorCommentReplyTableView.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        mentorCommentReplyTableView.tableView.contentInset = contentInset
        self.view.frame.origin.y -= keyboardFrame.height
        //moveTextField(textField, moveDistance: Int(-(keyboardFrame.height)), up: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        self.view.frame.origin.y += keyboardFrame.height
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        mentorCommentReplyTableView.tableView.contentInset = contentInset
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MentorCommentTableViewCell", for: indexPath) as! MentorCommentTableViewCell

            if !((object?.profileurl.isEmpty)!){
                cell.profile.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\((object?.profileurl)!)"),options:[],completionHandler:{
                    (image, error, cacheType, imageUrl) in
                    if(image == nil){
                        cell.profile.image = UIImage(named: "defaultImage")
                    }else{
                        cell.profile.image = image
                    }
                })
            }
            //if comments is that I created, signify it.
            if object?.user_id == userDefault.integer(forKey: "user_id"){
                cell.nicknameLabel.textColor = App.mainColor
            }else{
                //do nothing
            }
            cell.nicknameLabel.text = object?.user_nickname
            cell.commentLabel.text = object?.content
            cell.postedTimeLabel.text = CustomizedObject.calculateElapsedTime(created: (object?.comment_created)!)
            cell.numberOfrepliedComments.isHidden = true
            cell.replyButton.isHidden = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MentorCommentReplyTableViewCell", for: indexPath) as! MentorCommentReplyTableViewCell
            cell.replyButton.isHidden = true
            self.log.debug()
            if !(commentList[row].profileurl.isEmpty){
                cell.profile.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(commentList[row].profileurl)"),options:[],completionHandler:{
                    (image, error, cacheType, imageUrl) in
                    if(image == nil){
                        cell.profile.image = UIImage(named: "defaultImage")
                    }else{
                        cell.profile.image = image
                    }
                })
            }
            //if comments is that I created, signify it.
            if commentList[row].user_id == userDefault.integer(forKey: "user_id"){
                cell.nicknameLabel.textColor = App.mainColor
            }else{
                //do nothing
            }
            cell.nicknameLabel.text = commentList[row].user_nickname
            cell.commentLabel.text = commentList[row].content
            cell.postedTimeLabel.text = CustomizedObject.calculateElapsedTime(created: commentList[row].comment_created)
            // Check if the last row number is the same as the last current data element to load more comments
            if (row == commentList.count-1) {
                loadRepliedMentorComments(replied_comment_id:Int64(commentList[row].replied_comment_id),comment_id:Int64((object?.comment_id)!), scroll_is: "down")
                
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return commentList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0){
            textField.resignFirstResponder()
        }
        
    }
}

extension MentorCommentReplyTableViewController{
    
    func uploadCommentBtnTapped(){
        textField.resignFirstResponder()
        //if user has not typed anything, do nothing
        if (textField.text?.trimmed.isEmpty)!{
            return
        }
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = UploadRepliedMentorCommentRequest()
            request.commentId = Int64((object?.comment_id)!)
            request.mentorId = Int64((object?.mentor_id)!)
            request.userId = Int64(userDefault.integer(forKey: "user_id"))
            request.userNickname = userDefault.string(forKey: "user_nickname")
            request.content = textField.text?.trimmed
            request.receiverId = Int64((object?.user_id)!)
            
            GRPC.sharedInstance.authorizedUser.repliedMentorCommentUpload(with: request, handler:{
                (res,err) in
                
                if res != nil{
                    //self.uploadComment_protoCall?.finishWithError(nil)
                    self.textField.text = ""
                    self.textField.placeholder = "Comment here..."
                    //load replied comments on this comment
                    self.commentList.removeAll()
                    self.loadRepliedMentorComments(replied_comment_id:0,comment_id: Int64((self.object?.comment_id)!),scroll_is: "init")
                }else{
                    self.log.debug("Replied Comment Upload Error: \(err)")
                    //self.uploadComment_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Replied Comment Upload Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //uploadComment_protoCall?.timeout = App.timeout
            //uploadComment_protoCall?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    
    func loadRepliedMentorComments(replied_comment_id:Int64,comment_id:Int64,scroll_is:String){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetRepliedMentorCommentsRequest()
            request.repliedCommentId = replied_comment_id
            request.commentId = comment_id
            request.scrollIs = scroll_is
            self.log.debug()
            GRPC.sharedInstance.authorizedUser.getRepliedMentorComments(with: request, handler:{
                (res,err) in
                self.log.debug()
                if res != nil{
                    self.log.debug()
                    //self.getComment_protoCall?.finishWithError(nil)
                    for i in 0..<Int((res?.commentsArray_Count)!){
                        let res = res?.commentsArray.object(at: i) as! RepliedMentorComment
                        //Int this VC, MentorCommentObject.comment_id is replied_comment_id of reply_mentor_comment database
                        //comment_id is object?.comment_id 
                        let comment = MentorCommentObject(replied_comment_id:Int(res.repliedCommentId),comment_id: Int(res.repliedCommentId), mentor_id: Int(res.mentorId), user_id: Int(res.userId),receiver_id:Int(res.receiverId), user_nickname: res.userNickname, profileurl: res.profileurl, content: res.content, comment_created: res.commentCreated)
                        self.commentList.append(comment)
                    }
                    if(scroll_is == "init"){
                        self.mentorCommentReplyTableView.tableView.reloadData()
                        self.scrollToTappedComment()
                    }else{
                        //down
                        if(res?.commentsArray_Count == 0){
                            //no reload data
                        }else{
                            self.mentorCommentReplyTableView.tableView.reloadData()
                            self.scrollToTappedComment()
                        }
                    }
                }else{
                    self.log.debug("Replied Mentor Comments Error:\(err)")
                    //self.getComment_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Replied Mentor Comments Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //getComment_protoCall?.timeout = App.timeout
            //getComment_protoCall?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    
//    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
//        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
//        self.textField.frame = self.textField.frame.offsetBy(dx: 0, dy: movement)
//    }
    //if there is a comment that I tapped in SharedCommentVC among a number of comments
    //scroll to that comment
    func scrollToTappedComment(){
        //this userDefault value comes from SharedCommentVC
        //and this value removed when user goes back from SharedCommentVC to UniversityVC
        if userDefault.object(forKey: "replied_mentor_comment_id") != nil{
            let replied_comment_id = userDefault.integer(forKey: "replied_mentor_comment_id")
            //if commentList has the such comment_id of userDefault
            let index = commentList.index{$0.replied_comment_id == replied_comment_id}
            if index != nil{
                let indexPath = IndexPath(row: index!, section: 1)
                self.mentorCommentReplyTableView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
}



