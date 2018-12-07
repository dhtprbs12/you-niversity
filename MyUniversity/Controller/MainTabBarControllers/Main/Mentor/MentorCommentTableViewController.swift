//
//  MentorCommentTableViewController.swift
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

class MentorCommentTableViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    var mentorCommentTableView: MentorCommentTableView{
        return self.view as! MentorCommentTableView
    }
    let log = XCGLogger.default
    var uploadCommentBtn: RaisedButton!
    var textField : UITextField!
    let userDefault = UserDefaults.standard
    var commentList = [MentorCommentObject]()
    var object : MentorObject?
    
    var getNumberOfComments_protoCall : GRPCProtoCall?
    var loadComments_protoCall : GRPCProtoCall?
    var uploadComment_protoCall : GRPCProtoCall?
    
    override func loadView() {
        super.loadView()
        self.view = MentorCommentTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        mentorCommentTableView.tableView.delegate = self
        mentorCommentTableView.tableView.dataSource = self
        mentorCommentTableView.tableView.keyboardDismissMode = .interactive
        mentorCommentTableView.tableView.separatorStyle = .none
        mentorCommentTableView.tableView.rowHeight = UITableViewAutomaticDimension
        mentorCommentTableView.tableView.estimatedRowHeight = 100.0
        mentorCommentTableView.tableView.register(MentorCommentTableViewCell.self, forCellReuseIdentifier: "MentorCommentTableViewCell")
        
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
        uploadCommentBtn.rx.tap.subscribe({ [weak self] x in
            self?.uploadCommentBtnTapped()
        }).disposed(by: App.disposeBag)
        
        textField.rightViewMode = .always
        textField.rightView = uploadCommentBtn
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //load tapped comment in QandADetailVC from UserDefault
        let decoded  = userDefault.object(forKey: "mentor") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? MentorObject
        commentList.removeAll()
        loadMentorComments(mentor_id: Int64((object?.mentor_id)!), comment_id: 0,scroll_is: "init")
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
        
        var contentInset:UIEdgeInsets = mentorCommentTableView.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        mentorCommentTableView.tableView.contentInset = contentInset
        self.view.frame.origin.y -= keyboardFrame.height
        //moveTextField(textField, moveDistance: Int(-(keyboardFrame.height)), up: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        self.view.frame.origin.y += keyboardFrame.height
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        mentorCommentTableView.tableView.contentInset = contentInset
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if commentList.count == 0{
            count = 1
        }else{
            count = commentList.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentorCommentTableViewCell", for: indexPath) as! MentorCommentTableViewCell
        let row = indexPath.row
        if commentList.count == 0{
            cell.nicknameLabel.text = ""
            cell.dividerLabel.isHidden = true
            cell.commentLabel.text = "No Comments Yet"
            cell.postedTimeLabel.text = ""
            cell.replyButton.isHidden = true
        }else{
            cell.dividerLabel.isHidden = false
            cell.replyButton.isHidden = false
            //if there is profileurl, download it
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
            getNumberOfRepliedMentorComments(label:cell.numberOfrepliedComments,comment_id: Int64(commentList[row].comment_id))
            // Check if the last row number is the same as the last current data element to load more comments
            if (row == commentList.count-1) {
                loadMentorComments(mentor_id: Int64(commentList[row].mentor_id), comment_id: Int64(commentList[row].comment_id), scroll_is: "down")
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        //need to encode to store customized object into UserDefault
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.commentList[indexPath.row])
        self.userDefault.set(encodedData, forKey: "mentor_comment")
        //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
        self.userDefault.synchronize()
        let mentorCommentReplyTableViewVC = MentorCommentReplyTableViewController()
        mentorCommentReplyTableViewVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mentorCommentReplyTableViewVC, animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension MentorCommentTableViewController{
    func uploadCommentBtnTapped(){
        textField.resignFirstResponder()
        //if user has not typed anything, do nothing
        if (textField.text?.trimmed.isEmpty)!{
            return
        }
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = UploadMentorCommentRequest()
            //self.log.debug("comment_mentor_id:\(userDefault.integer(forKey: "comment_mentor_id"))")
            request.mentorId = Int64((self.object?.mentor_id)!)
            request.userId = Int64(userDefault.integer(forKey: "user_id"))
            request.userNickname = userDefault.string(forKey: "user_nickname")
            request.content = textField.text?.trimmed
            request.receiverId = Int64((self.object?.user_id)!)
            
            GRPC.sharedInstance.authorizedUser.mentorCommentUpload(with: request, handler:{
                (res,err) in
                
                if res != nil{
                    //self.uploadComment_protoCall?.finishWithError(nil)
                    self.textField.text = ""
                    self.textField.placeholder = "Comment here..."
                    self.commentList.removeAll()
                    self.loadMentorComments(mentor_id: Int64((self.object?.mentor_id)!), comment_id: 0,scroll_is: "init")
                }else{
                    self.log.debug("Comment Upload Error: \(err)")
                    //self.uploadComment_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Comment Upload Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //uploadComment_protoCall?.timeout = App.timeout
            //uploadComment_protoCall?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
        
    }
    //get all comments of this mentor
    func loadMentorComments(mentor_id : Int64,comment_id:Int64,scroll_is:String){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetMentorCommentsRequest()
            request.mentorId = mentor_id
            request.commentId = comment_id
            request.scrollIs = scroll_is
            GRPC.sharedInstance.authorizedUser.getMentorComments(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.loadComments_protoCall?.finishWithError(nil)
                    for i in 0..<Int((res?.commentsArray_Count)!){
                        let res = res?.commentsArray.object(at: i) as! MentorComment
                        let comment = MentorCommentObject(replied_comment_id:0,comment_id: Int(res.commentId), mentor_id: Int(res.mentorId), user_id: Int(res.userId),receiver_id:Int(res.receiverId), user_nickname: res.userNickname, profileurl: res.profileurl, content: res.content, comment_created: res.commentCreated)
                        self.commentList.append(comment)
                    }
                    if(scroll_is == "init"){
                        self.mentorCommentTableView.tableView.reloadData()
                        self.scrollToTappedComment()
                    }else{
                        //down
                        if(res?.commentsArray_Count == 0){
                            //no reload data
                        }else{
                            self.mentorCommentTableView.tableView.reloadData()
                            self.scrollToTappedComment()
                        }
                    }
                }else{
                    self.log.debug("Get Mentor Comments Error: \(err)")
                    //self.loadComments_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Mentor Comments Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //loadComments_protoCall?.timeout = App.timeout
            //loadComments_protoCall?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    
    func getNumberOfRepliedMentorComments(label: UILabel,comment_id:Int64){
        
        //get comments
        if CheckNetworkConnection.isConnectedToNetwork(){
            //create request
            let request = GetRepliedMentorCommentsRequest()
            request.commentId = comment_id
            
            GRPC.sharedInstance.authorizedUser.getRepliedMentorComments(with: request, handler:{
                (res,err) in
                if res != nil{
                    //self.getNumberOfComments_protoCall?.finishWithError(nil)
                    label.text = "\((res?.commentsArray_Count)!)"
                }else{
                    label.text = "0"
                    self.log.debug("getNumberOfRepliedMentorComments Error:\(err) : \(comment_id)")
                    //self.getNumberOfComments_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("getNumberOfRepliedMentorComments Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            
            //getNumberOfComments_protoCall?.timeout = App.timeout
            //getNumberOfComments_protoCall?.start()
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
        if userDefault.object(forKey: "mentor_comment_id") != nil{
            let comment_id = userDefault.integer(forKey: "mentor_comment_id")
            //if commentList has the such comment_id of userDefault
            let index = commentList.index{$0.comment_id == comment_id}
            if index != nil{
                let indexPath = IndexPath(row: index!, section: 0)
                self.mentorCommentTableView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
}


