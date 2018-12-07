//
//  CommentTableViewController.swift
//  MyUniversity
//
//  Created by 오세균 on 8/24/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import XCGLogger
import Then
import SnapKit
import Material
import PKHUD

class CommentTableViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    var commentTableView: CommentTableView{
        return self.view as! CommentTableView
    }
    let log = XCGLogger.default
    var uploadCommentBtn: RaisedButton!
    var textField : UITextField!
    let userDefault = UserDefaults.standard
    var commentList = [CommentObject]()
    var object : BoardObject?
    
    var getNumberOfComments_protoCall : GRPCProtoCall?
    var loadComments_protoCall : GRPCProtoCall?
    var uploadComment_protoCall : GRPCProtoCall?
    
    override func loadView() {
        super.loadView()
        self.view = CommentTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        commentTableView.tableView.delegate = self
        commentTableView.tableView.dataSource = self
        commentTableView.tableView.keyboardDismissMode = .interactive
        commentTableView.tableView.separatorStyle = .none
        commentTableView.tableView.rowHeight = UITableViewAutomaticDimension
        commentTableView.tableView.estimatedRowHeight = 100.0
        commentTableView.tableView.register(CollapsibleTableViewCell.self, forCellReuseIdentifier: "CollapsibleTableViewCell")
    
        //set textfield
        textField = UITextField().then{
            $0.backgroundColor = UIColor.white
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
            $0.setTitleColor(App.mainColor, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
        }
        uploadCommentBtn.rx.tap.subscribe({ [weak self] x in
            self?.uploadCommentBtnTapped()
        }).disposed(by: App.disposeBag)
        
        textField.rightViewMode = .always
        textField.rightView = uploadCommentBtn
        loadBoard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        textField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //키보드 보여질때와 없어질때 실행되는 notification을 탐지해서 그에 해당하는 메소드를 실행
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //keyboard appear
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = commentTableView.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        commentTableView.tableView.contentInset = contentInset
        self.view.frame.origin.y -= keyboardFrame.height
        //moveTextField(textField, moveDistance: Int(-(keyboardFrame.height)), up: true)
    }
    
    //keyboard disappear
    @objc func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        self.view.frame.origin.y += keyboardFrame.height
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        commentTableView.tableView.contentInset = contentInset
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollapsibleTableViewCell", for: indexPath) as! CollapsibleTableViewCell
        let row = indexPath.row
        if commentList.count == 0{
            cell.nicknameLabel.text = ""
            cell.dividerLabel.isHidden = true
            cell.commentLabel.text = "No Comments Yet"
            cell.postedTimeLabel.text = ""
            cell.replyButton.isHidden = true
        }else{
            //if comments is that I created, signify it.
            if commentList[row].user_id == userDefault.integer(forKey: "user_id"){
                cell.nicknameLabel.textColor = App.mainColor
            }else{
                //do nothing
            }
            cell.nicknameLabel.text = commentList[row].user_nickname
            cell.dividerLabel.isHidden = false
            cell.commentLabel.text = commentList[row].comment_content
            cell.postedTimeLabel.text = CustomizedObject.calculateElapsedTime(created: commentList[row].comment_created)
            getNumberOfRepliedComments(label:cell.numberOfrepliedComments,comment_id: commentList[row].comment_id)
            cell.replyButton.isHidden = false
            // Check if the last row number is the same as the last current data element to load more comments
            if (row == commentList.count-1) {
                loadComments(board_id: Int64(commentList[row].board_id), comment_id: Int64(commentList[row].comment_id), scroll_is: "down")
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when keyboard is up and user did select row, keyboard disappear
        textField.resignFirstResponder()
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
        //need to encode to store customized object into UserDefault
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: commentList[indexPath.row])
        userDefault.set(encodedData, forKey: "comment")
        //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
        userDefault.synchronize()
        let replyTableVC = ReplyViewController()
        replyTableVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(replyTableVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    //when user scrolls down, disappear keyboard
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0.0){
            self.textField.resignFirstResponder()
        }
    }
    
    //when user tap done, just disappear keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}

extension CommentTableViewController{
    
    func loadBoard(){
        let decoded  = userDefault.object(forKey: "board") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? BoardObject
        commentList.removeAll()//just in case
        loadComments(board_id: Int64((object?.board_id)!), comment_id: 0, scroll_is: "init")
    }
    
    func loadComments(board_id:Int64,comment_id:Int64,scroll_is:String){
        //get comments
        if CheckNetworkConnection.isConnectedToNetwork(){
            //create request
            let request = GetCommentsRequest()
            request.boardId = board_id
            request.commentId = comment_id
            request.scrollIs = scroll_is
            GRPC.sharedInstance.authorizedUser.getCommentsWith( request, handler:{
                (res,err) in
                if res != nil{
                    //self.loadComments_protoCall?.finishWithError(nil)
                    for i in 0..<Int((res?.commentsArray_Count)!){
                        let res = res?.commentsArray.object(at: i) as! Comment
                        let comment = CommentObject(comment_reply_id:0,comment_id:Int(res.commentId),board_id:Int(res.boardId),user_id:Int(res.userId),receiver_id:Int(res.receiverId),user_nickname:res.userNickname,comment_content:res.commentContent,comment_created:res.commentCreated)
                        
                        self.commentList.append(comment)
                    }
                    if(scroll_is == "init"){
                        self.commentTableView.tableView.reloadData()
                        self.scrollToTappedComment()
                    }else{
                        //down
                        if(res?.commentsArray_Count == 0){
                            //no reload data
                        }else{
                            self.commentTableView.tableView.reloadData()
                            self.scrollToTappedComment()
                        }
                    }
                }else{
                    self.log.debug("Get Comments Error: \(err)")
                    //self.loadComments_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Comments Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //loadComments_protoCall?.timeout = App.timeout
            //loadComments_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }
    
    func getNumberOfRepliedComments(label: UILabel,comment_id:Int){
        
        //get comments
        if CheckNetworkConnection.isConnectedToNetwork(){
            //create request
            let request = GetRepliedCommentsRequest()
            request.commentId = Int64(comment_id)
            
            GRPC.sharedInstance.authorizedUser.getRepliedComments(with: request, handler:{
                (res,err) in
                
                if res != nil{
                    //self.getNumberOfComments_protoCall?.finishWithError(nil)
                    label.text = "\((res?.commentsArray_Count)!)"
                }else{
                    label.text = "0"
                    self.log.debug("getNumberOfRepliedComments Error:\(err)")
                    //self.getNumberOfComments_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("getNumberOfRepliedComments Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //getNumberOfComments_protoCall?.timeout = App.timeout
            //getNumberOfComments_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }
    
    func uploadCommentBtnTapped(){
        textField.resignFirstResponder()
        //if user has not typed anything, do nothing
        if (textField.text?.trimmed.isEmpty)!{
            return
        }
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = CommentUploadRequest()
            request.boardId = Int64((object?.board_id)!)
            request.userId = Int64(userDefault.integer(forKey: "user_id"))
            request.userNickname = userDefault.string(forKey: "user_nickname")
            request.commentContent =
                textField.text?.trimmed
            request.receiverId = Int64((object?.user_id)!)
            
            GRPC.sharedInstance.authorizedUser.commentUpload(with: request, handler:{
                (res,err) in
                
                if res != nil{
                    //self.uploadComment_protoCall?.finishWithError(nil)
                    self.textField.text = ""
                    self.textField.placeholder = "Comment here..."
                    self.commentList.removeAll()
                    self.loadComments(board_id: Int64((self.object?.board_id)!), comment_id: 0, scroll_is: "init")
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
        if userDefault.object(forKey: "comment_id") != nil{
            let comment_id = userDefault.integer(forKey: "comment_id")
            //if commentList has the such comment_id of userDefault
            let index = commentList.index{$0.comment_id == comment_id}
            if index != nil{
                let indexPath = IndexPath(row: index!, section: 0)
                self.commentTableView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
}
