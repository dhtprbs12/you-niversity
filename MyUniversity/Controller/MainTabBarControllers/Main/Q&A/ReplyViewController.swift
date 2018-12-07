//
//  ReplyViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 4. 3..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import Material
import Then
import SnapKit

class ReplyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{

    var replyView: ReplyView{
        return self.view as! ReplyView
    }
    var log = XCGLogger.default
    var object : CommentObject?
    var userDefault = UserDefaults.standard
    var repliedComments = [CommentObject]()
    var textField : UITextField!
    var uploadCommentBtn: RaisedButton!
    
    var getComment_protoCall : GRPCProtoCall?
    var uploadComment_protoCall : GRPCProtoCall?
    
    override func loadView() {
        super.loadView()
        self.view = ReplyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //place UniversityDetailView under navigation bar
        self.edgesForExtendedLayout = []
        self.view.isUserInteractionEnabled = true
        replyView.tableView.register(CollapsibleTableViewCell.self, forCellReuseIdentifier: "CollapsibleTableViewCell")
        replyView.tableView.register(ReplyTableViewCell.self, forCellReuseIdentifier: "ReplyTableViewCell")
        replyView.tableView.delegate = self
        replyView.tableView.dataSource = self
        replyView.tableView.keyboardDismissMode = .interactive
        replyView.tableView.separatorStyle = .none
        replyView.tableView.rowHeight = UITableViewAutomaticDimension
        replyView.tableView.estimatedRowHeight = 100.0
        
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
        //load tapped comment in QandADetailVC from UserDefault
        let decoded  = userDefault.object(forKey: "comment") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? CommentObject
        repliedComments.removeAll()//just in case
        loadRepliedComments(comment_reply_id:0,comment_id:Int64((object?.comment_id)!),scroll_is:"init")
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
        
        var contentInset:UIEdgeInsets = replyView.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        replyView.tableView.contentInset = contentInset
        self.view.frame.origin.y -= keyboardFrame.height
        //moveTextField(textField, moveDistance: Int(-(keyboardFrame.height)), up: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        self.view.frame.origin.y += keyboardFrame.height
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        replyView.tableView.contentInset = contentInset
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 0
        if section == 0{
            count = 1
        }else{
            count = repliedComments.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let row = indexPath.row
        //show the tapped comment
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollapsibleTableViewCell", for: indexPath) as! CollapsibleTableViewCell
            
            cell.numberOfrepliedComments.isHidden = true
            cell.replyButton.isHidden = true
            //if comments is that I created, signify it.
            if object?.user_id == userDefault.integer(forKey: "user_id"){
                cell.nicknameLabel.textColor = App.mainColor
            }else{
                
            }
            cell.nicknameLabel.text = object?.user_nickname
            cell.commentLabel.text = object?.comment_content
            cell.postedTimeLabel.text = CustomizedObject.calculateElapsedTime(created: (object?.comment_created)!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath) as! ReplyTableViewCell
            if repliedComments.count == 0{
                cell.commentLabel.text = "No Replied Comments Yet"
                cell.dividerLabel.isHidden = true
                cell.nicknameLabel.text = ""
                cell.postedTimeLabel.text = ""
                
            }else{
                //if comments is that I created, signify it.
                if repliedComments[row].user_id == userDefault.integer(forKey: "user_id"){
                    cell.nicknameLabel.textColor = App.mainColor
                }else{
                    //do nothing
                }
                cell.commentLabel.text = repliedComments[row].comment_content
                cell.dividerLabel.isHidden = false
                cell.nicknameLabel.text = repliedComments[row].user_nickname
                cell.postedTimeLabel.text = CustomizedObject.calculateElapsedTime(created: repliedComments[row].comment_created)
                //load more
                if(row == repliedComments.count - 1){
                    loadRepliedComments(comment_reply_id:Int64(repliedComments[row].comment_reply_id),comment_id:Int64((object?.comment_id)!),scroll_is:"down")
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    //dynamic tableview cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //when user scrolls down, disappear keyboard
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0){
            textField.resignFirstResponder()
        }
    }
    
    //textFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    
}

extension ReplyViewController{
    func uploadCommentBtnTapped(){
        textField.resignFirstResponder()
        //if user has not typed anything, do nothing
        if (textField.text?.trimmed.isEmpty)!{
            return
        }
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = RepliedCommentUploadRequest()
            request.commentId = Int64((object?.comment_id)!)
            request.boardId = Int64((object?.board_id)!)
            request.userId = Int64(userDefault.integer(forKey: "user_id"))
            request.userNickname = userDefault.string(forKey: "user_nickname")
            request.commentContent = textField.text?.trimmed
            request.receiverId = Int64((object?.user_id)!)
            GRPC.sharedInstance.authorizedUser.repliedCommentUpload(with: request, handler:{
                (res,err) in
                
                if res != nil{
                    //self.uploadComment_protoCall?.finishWithError(nil)
                    self.textField.text = ""
                    self.textField.placeholder = "Comment here..."
                    self.repliedComments.removeAll()//just in case
                    self.loadRepliedComments(comment_reply_id:0,comment_id:Int64((self.object?.comment_id)!),scroll_is:"init")
                }else{
                    
                    self.log.debug("Replied Comments Upload Error:\(err)")
                    //self.uploadComment_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Replied Comments Upload Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //uploadComment_protoCall?.timeout = App.timeout
            //uploadComment_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }
    
    func loadRepliedComments(comment_reply_id:Int64,comment_id:Int64,scroll_is:String){
        //get comments
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetRepliedCommentsRequest()
            request.commentReplyId = comment_reply_id
            request.commentId = comment_id
            request.scrollIs = scroll_is
            GRPC.sharedInstance.authorizedUser.getRepliedComments(with: request, handler:{
                (res,err) in
                
                if res != nil{
                    //self.getComment_protoCall?.finishWithError(nil)
                    for i in 0..<Int((res?.commentsArray_Count)!){
                        let res = res?.commentsArray.object(at: i) as! RepliedComment
                        //because of ambigous reason
                        let comment = CommentObject(comment_reply_id:Int(res.commentReplyId),comment_id:Int(res.commentId),board_id:Int(res.boardId),user_id:Int(res.userId),receiver_id:Int(res.receiverId),user_nickname:res.userNickname,comment_content:res.commentContent,comment_created:res.commentCreated)
                        
                        self.repliedComments.append(comment)
                    }
                    if(scroll_is == "init"){
                        self.replyView.tableView.reloadData()
                        self.scrollToTappedComment()
                    }else{
                        //down
                        if(res?.commentsArray_Count == 0){
                            //no reload data
                        }else{
                            self.replyView.tableView.reloadData()
                            self.scrollToTappedComment()
                        }
                    }
                }else{
                    self.log.debug("Get Comments Error:\(err)")
                    //self.getComment_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Comments Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //getComment_protoCall?.timeout = App.timeout
            //getComment_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
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
        if userDefault.object(forKey: "replied_comment_id") != nil{
            let replied_comment_id = userDefault.integer(forKey: "replied_comment_id")
            //if commentList has the such comment_id of userDefault
            let index = repliedComments.index{$0.comment_reply_id == replied_comment_id}
            if index != nil{
                let indexPath = IndexPath(row: index!, section: 1)
                self.replyView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
}
