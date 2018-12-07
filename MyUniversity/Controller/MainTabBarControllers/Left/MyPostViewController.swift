//
//  MyPostViewController.swift
//  MyUniversity
//
//  Created by 오세균 on 7/17/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import XCGLogger
import RealmSwift

class MyPostViewController: UITableViewController{
    
    //var refresh = UIRefreshControl()
    var currentTable: UILabel!
    let userDefault = UserDefaults.standard
    let log = XCGLogger.default
    var boards = [BoardObject]()
    var get_protoCall : GRPCProtoCall?
    var delete_protoCall : GRPCProtoCall?
    
    override func loadView(){
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.separatorColor = UIColor.black
        //refresh.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.tableView.register(QandATableViewCell.self, forCellReuseIdentifier: "QandATableViewCell")
        //add refreshControl into tableview
        //self.tableView.addSubview(self.refresh)
        self.title = "My Post"
        getMyBoards(board_type: "post",my_id: userDefault.integer(forKey: "user_id"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if userDefault.bool(forKey: "Is_Post_Revised") == true{
            
            //if my post has been revised, get boards again
            getMyBoards(board_type: "post",my_id: userDefault.integer(forKey: "user_id"))
        }else{
            //do nothing
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userDefault.set(false, forKey: "Is_Post_Revised")
//        if(self.isMovingToParentViewController){
//            get_protoCall?.finishWithError(nil)
//            delete_protoCall?.finishWithError(nil)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //refreshControl method
    //need to call server to get refresh recently created data when user scroll down tableView
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        //refresh method here
//        getMyBoards(board_type: "post",my_id: userDefault.integer(forKey: "user_id"))
//        refresh.endRefreshing()
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "QandATableViewCell", for: indexPath) as! QandATableViewCell
        
        cell.titleLabel.text = boards[row].board_title
        cell.nicknameLabel.text = boards[row].user_nickname
        cell.detailLabel.text =  boards[row].board_content
        cell.uploadTime.text = CustomizedObject.calculateElapsedTime(created: boards[row].board_created)
        //cell.uploadTime.text = boards[row].board_created
        cell.visitCount.text = String(boards[row].touch_count)
        cell.commentCount.text = String(boards[row].comment_count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Caution", message: "It's your post.\nWhat do you want to do?\n\nEx:) Swipe the view to delete", preferredStyle: .actionSheet)
        let revisionAction = UIAlertAction(title: "Revision", style: .default) { (_) in
            //need to encode to store customized object into UserDefault
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.boards[indexPath.row])
            self.userDefault.set(encodedData, forKey: "board")
            //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
            self.userDefault.synchronize()
            let vc = RevisionMyBoardViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let commentAction = UIAlertAction(title: "Comments", style: .default) { _ in
            //need to encode to store customized object into UserDefault
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.boards[indexPath.row])
            self.userDefault.set(encodedData, forKey: "board")
            //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
            self.userDefault.synchronize()
            let vc = CommentTableViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(revisionAction)
        alertController.addAction(commentAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteMyBoard(board_id: Int64(boards[indexPath.row].board_id),indexPath:indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension MyPostViewController{
    func getMyBoards(board_type:String,my_id:Int){
        if CheckNetworkConnection.isConnectedToNetwork(){
            
            //need to remove all data of array to prevent duplicated
            boards.removeAll()
            //create request
            let request = MyBoardsRequest()
            request.userId = Int64(self.userDefault.integer(forKey: "user_id"))
            request.boardType = board_type
            
            //no need to set boardUniversity in QandA because it only needs to show all board of all university
            //server call
            GRPC.sharedInstance.authorizedUser.getMyBoards(with: request, handler: {
                (res,err) in
                //self.get_protoCall?.finishWithError(nil)
                if res != nil{
                    
                    for i in 0..<Int((res?.boardsArray_Count)!){
                        let res = res?.boardsArray.object(at: i) as! Board
                        //because of ambigous reason
                        let board = BoardObject(board_id:Int(res.boardId),user_id:Int(res.userId),board_type:res.boardType,board_university:res.boardUniversity,board_major:res.boardMajor,board_title : res.boardTitle,board_content: res.boardContent,touch_count: Int(res.boardTouchCount),comment_count: Int(res.boardCommentCount),board_created : res.boardCreated,user_nickname:res.userNickname)
                        
                        self.boards.append(board)
                    }
                    self.tableView.reloadData()
                }else{
                    self.log.debug("get my boards error:\(err)")
                    //self.get_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get My Boards Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //GRPC.sharedInstance.rpcCall.cancel()
            })
            //get_protoCall?.timeout = App.timeout
            //get_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }
    
    func deleteMyBoard(board_id:Int64,indexPath:IndexPath){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = DeleteMyBoardRequest()
            request.boardId = board_id
            
            GRPC.sharedInstance.authorizedUser.deleteMyBoard(with: request, handler: {
                (res, err) in
                
                if res != nil{
                    //self.delete_protoCall?.finishWithError(nil)
                    self.view.window?.makeToast("Successfully Deleted", duration: 1.0, position: CSToastPositionBottom)
                    self.boards.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)

                }else{
                    
                    self.log.debug("Delete My Board Error:\(err)")
                    //self.delete_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Delete My Board Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //GRPC.sharedInstance.rpcCall.cancel()
            })
            //delete_protoCall?.timeout = App.timeout
            //delete_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }
}
