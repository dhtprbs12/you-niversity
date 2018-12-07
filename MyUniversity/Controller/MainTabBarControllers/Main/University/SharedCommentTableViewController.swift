//
//  SharedCommentTableViewController.swift
//  MyUniversity
//
//  Created by 오세균 on 8/22/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import XCGLogger
import Then
import SnapKit
import Material
import PKHUD

class SharedCommentTableViewController:UITableViewController,UITextFieldDelegate{

    let log = XCGLogger.default
    let userDefault = UserDefaults.standard
    var commentList = [CommentObject]()
    var mentor_commentList = [MentorCommentObject]()
    
    var load_shared_comments_protoCall : GRPCProtoCall?
    var loadComments_protoCall : GRPCProtoCall?
    var loadRepliedComments_protoCall : GRPCProtoCall?
    var loadMentorComments_protoCall : GRPCProtoCall?
    var loadRepliedMentorComments_protoCall : GRPCProtoCall?
    
    var longString : String!
    var commentRange : NSRange!
    var repliedCommentRange : NSRange!
    var longAttributedStr :NSMutableAttributedString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.dataSource = self
        //this is for comment only
        self.tableView.register(CollapsibleTableViewCell.self, forCellReuseIdentifier: "CollapsibleTableViewCell")
        //this is for mentor_comment only
        self.tableView.register(MentorCommentTableViewCell.self, forCellReuseIdentifier: "MentorCommentTableViewCell")
        commentList.removeAll()
        mentor_commentList.removeAll()
        loadSharedComments(user_id: Int64(userDefault.integer(forKey: "user_id")))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.tabBarController?.tabBar.isHidden = true
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        //when it goes back to University VC, remove userDefault
        if (self.isMovingFromParentViewController) {
            self.log.debug()
            userDefault.removeObject(forKey: "comment_id")
            userDefault.removeObject(forKey: "replied_comment_id")
            userDefault.removeObject(forKey: "mentor_comment_id")
            userDefault.removeObject(forKey: "replied_mentor_comment_id")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if indexPath.section == 0{
            //General
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollapsibleTableViewCell", for: indexPath) as! CollapsibleTableViewCell
            cell.replyButton.isHidden = true
            
            if commentList.count == 0{
                cell.nicknameLabel.text = ""
                cell.dividerLabel.isHidden = true
                cell.commentLabel.text = "No Comments Yet"
                cell.postedTimeLabel.text = ""
                cell.numberOfrepliedComments.text = ""
            }else{
                cell.nicknameLabel.text = commentList[row].user_nickname
                cell.dividerLabel.isHidden = false
                if commentList[row].comment_reply_id == 0{
                    //just comment
                    longString = "\(commentList[row].user_nickname) commented on your board: \(commentList[row].comment_content)"
                    commentRange = (longString as NSString).range(of: "commented on your board:")
                    longAttributedStr = NSMutableAttributedString(string: longString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
                    longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.blue], range: commentRange)
                    cell.commentLabel.attributedText = longAttributedStr
//                    cell.commentLabel.text = "\(commentList[row].user_nickname) commented on your board: \(commentList[row].comment_content)"
                }else{
                    //just replied comment
                    longString = "\(commentList[row].user_nickname) commented on your comment: \(commentList[row].comment_content)"
                    commentRange = (longString as NSString).range(of: "commented on your comment:")
                    longAttributedStr = NSMutableAttributedString(string: longString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
                    longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.blue], range: commentRange)
                    cell.commentLabel.attributedText = longAttributedStr
//                    cell.commentLabel.text = "\(commentList[row].user_nickname) commented on your comment: \(commentList[row].comment_content)"
                }
                cell.postedTimeLabel.text = CustomizedObject.calculateElapsedTime(created: commentList[row].comment_created)
                cell.numberOfrepliedComments.text = ""
            }
            
            return cell
        }else{
            //Mentor
            if mentor_commentList.count == 0{
                //when there is nothing, just show no comments
                let cell = tableView.dequeueReusableCell(withIdentifier: "CollapsibleTableViewCell", for: indexPath) as! CollapsibleTableViewCell
                cell.replyButton.isHidden = true
                cell.nicknameLabel.text = ""
                cell.dividerLabel.isHidden = true
                cell.commentLabel.text = "No Comments Yet"
                cell.postedTimeLabel.text = ""
                cell.numberOfrepliedComments.text = ""
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MentorCommentTableViewCell", for: indexPath) as! MentorCommentTableViewCell
                cell.replyButton.isHidden = true
                cell.dividerLabel.isHidden = false
                
                //if there is an profile url, set
                if !(mentor_commentList[row].profileurl.isEmpty){
                    cell.profile.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(mentor_commentList[row].profileurl)"),options:[],completionHandler:{
                        (image, error, cacheType, imageUrl) in
                        if(image == nil){
                            cell.profile.image = UIImage(named: "defaultImage")
                        }else{
                            cell.profile.image = image
                        }
                    })
                }else{
                    //if not, set it defaultImage
                    cell.profile.image = UIImage(named:"defaultImage")
                }
                if mentor_commentList[row].replied_comment_id == 0{
                    //just comment
                    longString = "\(mentor_commentList[row].user_nickname) commented on your mentor info: \(mentor_commentList[row].content)"
                    commentRange = (longString as NSString).range(of: "commented on your mentor info:")
                    longAttributedStr = NSMutableAttributedString(string: longString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
                    longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.blue], range: commentRange)
                    cell.commentLabel.attributedText = longAttributedStr
                    //cell.commentLabel.text = "\(mentor_commentList[row].user_nickname) commented on your mentor info: \(mentor_commentList[row].content)"
                }else{
                    //just replied comment
                    longString = "\(mentor_commentList[row].user_nickname) commented on your comment: \(mentor_commentList[row].content)"
                    commentRange = (longString as NSString).range(of: "commented on your comment:")
                    longAttributedStr = NSMutableAttributedString(string: longString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
                    longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.blue], range: commentRange)
                    cell.commentLabel.attributedText = longAttributedStr
                    //cell.commentLabel.text = "\(mentor_commentList[row].user_nickname) commented on your comment: \(mentor_commentList[row].content)"
                }
                cell.nicknameLabel.text = mentor_commentList[row].user_nickname
                cell.postedTimeLabel.text = CustomizedObject.calculateElapsedTime(created: mentor_commentList[row].comment_created)
                cell.numberOfrepliedComments.text = ""
                return cell
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "General"
        }else{
            return "Mentor"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0{
            if commentList.count == 0{
                return 1
            }else{
                return commentList.count
            }
        }else{
            if mentor_commentList.count == 0{
                return 1
            }else{
                return mentor_commentList.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        if indexPath.section == 0{
            //user tap general tableview
            //check if it is comment or replied comment
            if commentList[indexPath.row].comment_reply_id == 0{
                //this is just comment
                loadComments(board_id: Int64(commentList[indexPath.row].board_id))
                //set userDefault to scroll to this comment in CommentTableVC
                userDefault.set(commentList[indexPath.row].comment_id, forKey: "comment_id")
            }else{
                //this is replied comment
                loadRepliedComments(comment_id: Int64(commentList[indexPath.row].comment_id))
                userDefault.set(commentList[indexPath.row].comment_reply_id, forKey: "replied_comment_id")
            }
        }else{
            //user tap mentor tableview
            //check if it is comment or replied comment
            if mentor_commentList[indexPath.row].replied_comment_id == 0{
                //this is just mentor comment
                loadMentorComments(mentor_id: Int64(mentor_commentList[indexPath.row].mentor_id))
                userDefault.set(mentor_commentList[indexPath.row].comment_id, forKey: "mentor_comment_id")
            }else{
                //this is replied mentor comment
                loadRepliedMentorComments(comment_id: Int64(mentor_commentList[indexPath.row].comment_id))
                userDefault.set(mentor_commentList[indexPath.row].replied_comment_id, forKey: "replied_mentor_comment_id")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension SharedCommentTableViewController{
    //get all comments of my user_id
    func loadSharedComments(user_id : Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetSharedCommentsRequest()
            request.userId  = user_id
            
            GRPC.sharedInstance.authorizedUser.getSharedComments(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.load_shared_comments_protoCall?.finishWithError(nil)
                    DispatchQueue.global(qos: .userInitiated).async {
                        //comment
                        for i in 0..<Int((res?.commentsArray_Count)!){
                            let res = res?.commentsArray.object(at: i) as! Comment
                            //if comments that I created, ignore it
                            if res.userId != self.userDefault.integer(forKey: "user_id"){
                                let comment = CommentObject(comment_reply_id:0,comment_id:Int(res.commentId),board_id:Int(res.boardId),user_id:Int(res.userId),receiver_id:Int(res.receiverId),user_nickname:res.userNickname,comment_content:res.commentContent,comment_created:res.commentCreated)
                                self.commentList.append(comment)
                            }
                        }
                        //replied_comment
                        for j in 0..<Int((res?.repliedCommentsArray_Count)!){
                            let res = res?.repliedCommentsArray.object(at: j) as! RepliedComment
                            if res.userId != self.userDefault.integer(forKey: "user_id"){
                                let comment = CommentObject(comment_reply_id:Int(res.commentReplyId),comment_id:Int(res.commentId),board_id:Int(res.boardId),user_id:Int(res.userId),receiver_id:Int(res.receiverId),user_nickname:res.userNickname,comment_content:res.commentContent,comment_created:res.commentCreated)
                                self.commentList.append(comment)
                            }
                        }
                        //mentor_comment
                        for k in 0..<Int((res?.mentorCommentsArray_Count)!){
                            let res = res?.mentorCommentsArray.object(at: k) as! MentorComment
                            if res.userId != self.userDefault.integer(forKey: "user_id"){
                                let comment = MentorCommentObject(replied_comment_id:0,comment_id: Int(res.commentId), mentor_id: Int(res.mentorId), user_id: Int(res.userId), receiver_id: Int(res.receiverId), user_nickname: res.userNickname, profileurl: res.profileurl, content: res.content, comment_created: res.commentCreated)
                                self.mentor_commentList.append(comment)
                            }
                        }
                        //replied_mentor_comment
                        for l in 0..<Int((res?.repliedMentorCommentsArray_Count)!){
                            let res = res?.repliedMentorCommentsArray.object(at: l) as! RepliedMentorComment
                            if res.userId != self.userDefault.integer(forKey: "user_id"){
                                let comment = MentorCommentObject(replied_comment_id:Int(res.repliedCommentId),comment_id: Int(res.commentId), mentor_id: Int(res.mentorId), user_id: Int(res.userId), receiver_id: Int(res.receiverId), user_nickname: res.userNickname, profileurl: res.profileurl, content: res.content, comment_created: res.commentCreated)
                                self.mentor_commentList.append(comment)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }else{
                    self.log.debug("Get Shared Comments Error: \(err)")
                    //self.load_shared_comments_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Shared Comments Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //load_shared_comments_protoCall?.timeout = App.timeout
            //load_shared_comments_protoCall?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    //here figure out...
    //load comments
    func loadComments(board_id:Int64){
        //get comments
        if CheckNetworkConnection.isConnectedToNetwork(){
            var call: GRPCProtoCall?
            let request = GetBoardObjectRequest()
            request.boardId = board_id
            
            GRPC.sharedInstance.authorizedUser.getBoardObject(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //call?.finishWithError(nil)
                    let res = (res?.board)!
                    
                    let board = BoardObject(board_id:Int(res.boardId),user_id:Int(res.userId),board_type:res.boardType,board_university:res.boardUniversity,board_major:res.boardMajor,board_title : res.boardTitle,board_content: res.boardContent,touch_count: Int(res.boardTouchCount),comment_count: Int(res.boardCommentCount),board_created : res.boardCreated,user_nickname:res.userNickname)
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: board)
                    self.userDefault.set(encodedData, forKey: "board")
                    self.userDefault.synchronize()
                    let vc = CommentTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.log.debug("Get Board Object Error: \(err)")
                    //call?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Board Object Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //call?.timeout = App.timeout
            //call?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    //load replied comments
    func loadRepliedComments(comment_id:Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            var call: GRPCProtoCall?
            let request = GetCommentObjectRequest()
            request.commentId = comment_id
            
            GRPC.sharedInstance.authorizedUser.getCommentObject(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //call?.finishWithError(nil)
                    let res = (res?.comment)!
                    
                    let comment = CommentObject(comment_reply_id:0,comment_id:Int(res.commentId),board_id:Int(res.boardId),user_id:Int(res.userId),receiver_id:Int(res.receiverId),user_nickname:res.userNickname,comment_content:res.commentContent,comment_created:res.commentCreated)
                    
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: comment)
                    self.userDefault.set(encodedData, forKey: "comment")
                    self.userDefault.synchronize()
                    let vc = ReplyViewController()
                    vc.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.log.debug("Get Comment Object Error: \(err)")
                    //call?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Comment Object Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //call?.timeout = App.timeout
            //call?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    //load mentor comments
    func loadMentorComments(mentor_id:Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            var call: GRPCProtoCall?
            let request = GetMentorObjectRequest()
            request.mentorId = mentor_id
            
            GRPC.sharedInstance.authorizedUser.getMentorObject(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //call?.finishWithError(nil)
                    let res = (res?.mentor)!
                    
                    let mentor = MentorObject(number_id:Int(res.numberId),mentor_id:Int(res.mentorId),user_id:Int(res.userId),mentor_nickname:res.mentorNickname,mentor_university:res.mentorUniversity,mentor_major:res.mentorMajor,mentor_backgroundurl:res.mentorBackgroundurl,mentor_profileurl:res.mentorProfileurl,mentor_mentoring_area:res.mentorMentoringArea,mentor_mentoring_field:res.mentorMentoringField,mentor_introduction:res.mentorIntroduction,mentor_information:res.mentorInformation,mentor_touch_count:Int(res.mentorTouchCount),mentor_favorite_count:Int(res.mentorFavoriteCount),mentor_is_active:Int(res.mentorIsActive),mentor_created_at:res.mentorCreatedAt)
                    
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: mentor)
                    self.userDefault.set(encodedData, forKey: "mentor")
                    self.userDefault.synchronize()
                    let vc = MentorCommentTableViewController()
                    vc.hidesBottomBarWhenPushed = true

                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.log.debug("Get Mentor Object Error: \(err)")
                    //call?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Mentor Object Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //call?.timeout = App.timeout
            //call?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    //load replied mentor comments
    func loadRepliedMentorComments(comment_id:Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            var call: GRPCProtoCall?
            let request = GetMentorCommentObjectRequest()
            request.commentId = comment_id
            
            GRPC.sharedInstance.authorizedUser.getMentorCommentObject(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //call?.finishWithError(nil)
                    let res = (res?.comment)!
                    
                    let comment = MentorCommentObject(replied_comment_id:0,comment_id: Int(res.commentId), mentor_id: Int(res.mentorId), user_id: Int(res.userId),receiver_id:Int(res.receiverId), user_nickname: res.userNickname, profileurl: res.profileurl, content: res.content, comment_created: res.commentCreated)
                    
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: comment)
                    self.userDefault.set(encodedData, forKey: "mentor_comment")
                    self.userDefault.synchronize()
                    let vc = MentorCommentReplyTableViewController()
                    vc.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.log.debug("Get Mentor Comment Object Error: \(err)")
                    //call?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Mentor Comment Object Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //call?.timeout = App.timeout
            //call?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
}
