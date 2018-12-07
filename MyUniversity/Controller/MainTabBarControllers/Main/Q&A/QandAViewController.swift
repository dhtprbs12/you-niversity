//
//  BulletinBoardViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 17..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import XCGLogger

class QandAViewController: UITableViewController{
    
    var option: String = "Common Board"
    var refresh = UIRefreshControl()
    var currentTable: UILabel!
    let userDefault = UserDefaults.standard
    let log = XCGLogger.default
    var boards = [BoardObject]()
    var longString : String!
    var advantageRange : NSRange!
    var disadvantageRange : NSRange!
    var briefRange : NSRange!
    var longAttributedStr :NSMutableAttributedString!
    var check_deleted_protoCall : GRPCProtoCall?
    var touch_protoCall : GRPCProtoCall?
    var get_protoCall : GRPCProtoCall?
    var delete_protoCall : GRPCProtoCall?
    
    override func loadView(){
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.separatorColor = UIColor.black
        //refresh control user interaction
        refresh.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.tableView.register(QandATableViewCell.self, forCellReuseIdentifier: "QandATableViewCell")
        self.tableView.register(UniversityDetailTableViewCell.self, forCellReuseIdentifier: "UniversityDetailTableViewCell")
        //add refreshControl into tableview
        self.tableView.addSubview(self.refresh)
        //insert label into tableView
        currentTable = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        currentTable.textColor = App.mainColor
        currentTable.font = UIFont.boldSystemFont(ofSize: 20)
        currentTable.textAlignment = .center
        self.tableView.tableHeaderView = currentTable
        //when user choose one of the options in FABMenuVC, refresh tableview
        NotificationCenter.default.addObserver(self, selector: #selector(selectOption), name: NSNotification.Name(rawValue: "qandaTable"), object: nil)
        
        //get boards from the server
        boards.removeAll()
        getBoards(board_type:option,board_id: 0,scroll_is: "init")
        //view did load called once when the app loaded
        
    }
    //show tabbar and hide nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        currentTable.text = option
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //check_deleted_protoCall?.finishWithError(nil)
        //get_protoCall?.finishWithError(nil)
        //delete_protoCall?.finishWithError(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //refreshControl method
    //need to call server to get refresh recently created data when user scroll down tableView
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if(boards.count != 0){
            //refresh method here
            getBoards(board_type: option,board_id: boards[0].board_id,scroll_is: "up")
        }else{
            getBoards(board_type: option,board_id: 0,scroll_is: "up")
        }
        refresh.endRefreshing()
    }
    
    //notification handler
    @objc func selectOption(notification: NSNotification){
        //load data here
        if let selected = notification.userInfo!["option"] as? String {
            if(selected == "Create Board"){
                

                    //this is for navigation title of createExpressVC
                userDefault.set(option, forKey: "tableName")
                let vc = CreateExpressViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                
                option = selected
                currentTable.text = option
                //getBoards() has reloadData() anyway
                boards.removeAll()
                getBoards(board_type: option,board_id: 0,scroll_is: "init")
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if(option == "Universities Review"){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityDetailTableViewCell", for: indexPath) as! UniversityDetailTableViewCell
            cell.titleLabel.text = "\(boards[row].board_university)-\(boards[row].board_major):\(boards[row].board_title)"
            if boards[row].user_id == userDefault.integer(forKey: "user_id"){
                cell.nicknameLabel.textColor = UIColor.blue
            }else{
                
            }
            cell.nicknameLabel.text = boards[row].user_nickname
            cell.uploadTime.text = CustomizedObject.calculateElapsedTime(created: boards[row].board_created)
            cell.visitCount.text = String(boards[row].touch_count)
            cell.commentCount.text = String(boards[row].comment_count)
            cell.detailLabel.text =  boards[row].board_title
            cell.opinionLabel.sizeToFit()
            longString = boards[row].board_content
            
            advantageRange = (longString as NSString).range(of: "Advantage:")
            disadvantageRange = (longString as NSString).range(of: "Disadvantage:")
            briefRange = (longString as NSString).range(of: "Brief:")
            
            longAttributedStr = NSMutableAttributedString(string: longString, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
            longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.red], range: advantageRange)
            longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.blue], range: disadvantageRange)
            longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)], range: briefRange)
            
            cell.opinionLabel.attributedText = longAttributedStr
            
            // Check if the last row number is the same as the last current data element to load more boards
            if (row == boards.count-1) {
                
                getBoards(board_type: option, board_id: boards[boards.count - 1].board_id, scroll_is: "down")
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QandATableViewCell", for: indexPath) as! QandATableViewCell
            cell.titleLabel.text = "\(boards[row].board_university)-\(boards[row].board_major):\(boards[row].board_title)"
            if boards[row].user_id == userDefault.integer(forKey: "user_id"){
                cell.nicknameLabel.textColor = UIColor.blue
            }else{
                
            }
            cell.nicknameLabel.text = boards[row].user_nickname
            cell.detailLabel.text =  boards[row].board_content
            cell.uploadTime.text = CustomizedObject.calculateElapsedTime(created: boards[row].board_created)
            //self.log.debug("\(boards[row].board_created) -- \(CustomizedObject.calculateElapsedTime(created: boards[row].board_created))")
            //cell.uploadTime.text = boards[row].board_created
            cell.visitCount.text = String(boards[row].touch_count)
            cell.commentCount.text = String(boards[row].comment_count)
            // Check if the last row number is the same as the last current data element to load more boards
            if (row == boards.count-1) {
                self.log.debug()
                getBoards(board_type: option, board_id: boards[boards.count - 1].board_id, scroll_is: "down")
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.cellForRow(at: indexPath)?.isSelected = false
        //check if the board is that I created
        if boards.count == 0{
            return
        }
        //check if board is deleted
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = CheckIfItsDeletedRequest()
            request.id_p = Int64(boards[indexPath.row].board_id)
            request.type = Int64(1)
            GRPC.sharedInstance.authorizedUser.checkIfItsDeleted(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.check_deleted_protoCall?.finishWithError(nil)
                    if(res?.isDeleted == "true"){
                        self.view.window?.makeToast("The Board Just Deleted", duration: 1.5, position: CSToastPositionBottom)
                        return
                    }else{
                        
                        self.userDefault.set(self.option, forKey: "tableName")
                        //need to encode to store customized object into UserDefault
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.boards[indexPath.row])
                        self.userDefault.set(encodedData, forKey: "board")
                        //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
                        self.userDefault.synchronize()
                        let qandaVC = QandADetailViewController()
                        qandaVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(qandaVC, animated: true)
                        
                        //board is not deleted update touch count
                        self.boardTouch(board_id: Int64(self.boards[indexPath.row].board_id))
                    }
                    
                }else{
                    self.log.debug("Check Board Deleted Error:\(err)")
                    //self.check_deleted_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Check Board Deleted Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //check_deleted_protoCall?.timeout = App.timeout
            //check_deleted_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
//        let realm = try! Realm()
//        let board_user_id = boards[indexPath.row].user_id
//
//        if let user = realm.objects(UserInfo.self).first{
//            //if board is that I created,
//            if user.user_id == board_user_id{
//
//                let alertController = UIAlertController(title: "Caution", message: "It's your post.\nWhat do you want to do?\n\nOption.1 Swipe the view to delete\nOption.2 Check your post on the left side to revise this", preferredStyle: .actionSheet)
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
//
//            }else{//it is others
//
//            }
//        }else{
//            //else of let user_id = realm.objects(UserInfo.self).first?.user_id
//            //do nothing
//        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if(boards[indexPath.row].user_id == userDefault.integer(forKey: "user_id")){
                let alertController = UIAlertController(title: "Caution", message: "Are you sure?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
                let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
                    self.deleteMyBoard(board_id: Int64(self.boards[indexPath.row].board_id),indexPath:indexPath)
                }
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                
                self.present(alertController, animated: true, completion: nil)

                
            }else{
                self.view.window?.makeToast("Unable Delete Others", duration: 1.0, position: CSToastPositionBottom)
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat!
        if(option == "Universities Review"){
            height = 250.0
        }else{
            height = 100.0
        }
        return height
    }
    
    deinit{
        log.debug("QandAViewController deinit")
    }
}

extension QandAViewController{
    
    
    //helper function to get boards from the server
    func getBoards(board_type:String,board_id:Int,scroll_is:String){
        
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = BoardsRequest()
            //create request
            request.boardId = Int64(board_id)
            request.boardType = board_type
            request.scrollIs = scroll_is
            
            
            //no need to set boardUniversity in QandA because it only needs to show all board of all university
            //server call
            GRPC.sharedInstance.authorizedUser.getBoardsWith( request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.get_protoCall?.finishWithError(nil)
                    for i in 0..<Int((res?.boardsArray_Count)!){
                        let res = res?.boardsArray.object(at: i) as! Board
                        //because of ambigous reason
                        let board = BoardObject(board_id:Int(res.boardId),user_id:Int(res.userId),board_type:res.boardType,board_university:res.boardUniversity,board_major:res.boardMajor,board_title : res.boardTitle,board_content: res.boardContent,touch_count: Int(res.boardTouchCount),comment_count: Int(res.boardCommentCount),board_created : res.boardCreated,user_nickname:res.userNickname)
                        
                        if(scroll_is == "init" || scroll_is == "down"){
                            self.boards.append(board)
                        }else{
                            //if it is refresh == up
                            //insert it to the front
                            self.boards.insert(board,at:0)
                        }
                    }
                    if(scroll_is == "init"){
                        self.tableView.reloadData()
                    }else if(scroll_is == "up"){
                        if(res?.boardsArray_Count == 0){
                            //no reload data
                        }else{
                            self.tableView.reloadData()
                        }
                    }else{
                        if(res?.boardsArray_Count == 0){
                            //no reload data
                        }else{
                            self.tableView.reloadData()
                        }
                    }
                    
                }else{
                    self.log.debug("get boards error:\(err)")
                    //self.get_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Boards Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //GRPC.sharedInstance.rpcCall.finishWithError(nil)
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
    
    func boardTouch(board_id:Int64){
        let request = BoardTouchRequest()
        request.boardId = board_id
        
        GRPC.sharedInstance.authorizedUser.boardTouch(with: request, handler: {
            (res, err) in
            
            if res != nil{
                //self.touch_protoCall?.finishWithError(nil)
            }else{
                
                self.log.debug("Board Touch error:\(err)")
                //self.touch_protoCall?.finishWithError(err)
                if(err != nil){
                    self.view.window?.makeToast("Board Touch", duration: 1.0, position: CSToastPositionBottom)
                }
            }
            //GRPC.sharedInstance.rpcCall.cancel()
        })
        
        //touch_protoCall?.timeout = App.timeout
        //touch_protoCall?.start()
    }
}

