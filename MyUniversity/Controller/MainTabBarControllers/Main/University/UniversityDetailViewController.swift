//
//  UniversityDetailViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 29..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material
import Then
import SnapKit
import XCGLogger
import RealmSwift
import Kingfisher


class UniversityDetailViewController: UITableViewController{

    var refresh = UIRefreshControl()
    var univDetailView : UniversityDetailView!
    var item : String = "Info"
    var object : UniversityObject?
    let userDefault = UserDefaults.standard
    var tapGesture: UITapGestureRecognizer!
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
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //if uncomment this, tabbar doesn't disappear
        //place UniversityDetailView under navigation bar
        //self.edgesForExtendedLayout = []
        
        univDetailView = UniversityDetailView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.width / 3+60))//uisegmentcontrol's default height: 44
        self.tableView.tableHeaderView  = univDetailView
        //refresh control user interaction
        refresh.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        
        self.tableView.register(UniversityInfoTableViewCell.self, forCellReuseIdentifier: "UniversityInfoTableViewCell")
        self.tableView.register(UniversityDetailTableViewCell.self, forCellReuseIdentifier: "UniversityDetailTableViewCell")
        self.tableView.register(QandATableViewCell.self, forCellReuseIdentifier: "QandATableViewCell")
        self.tableView.addSubview(self.refresh)
        
        
        univDetailView.segmentView.addTarget(self, action: #selector(selectItem), for: .valueChanged)
        
        //load university info from UserDefaults
        let decoded  = userDefault.object(forKey: "university") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UniversityObject
        
        
        univDetailView.univName.text = object?.name
        self.univDetailView.univBackgroundImage.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/universities/\((self.object?.crawling_url)!)"), completionHandler: {
            (image, error, cacheType, imageUrl) in
            
            if image == nil{
                //fail to load
                self.univDetailView.univBackgroundImage.backgroundColor = UIColor.lightGray
            }else{
                //update ui
                self.univDetailView.univBackgroundImage.image = image
            }
        })
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapResponse(_:)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        check_deleted_protoCall?.finishWithError(nil)
//        get_protoCall?.finishWithError(nil)
//        delete_protoCall?.finishWithError(nil)
    }

    //refreshControl method
    //need to call server to get refresh recently created data when user scroll down tableView
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //refresh method here
        if(item == "Info"){
            //do nothing
        }else if(item == "Q&A"){
            if(boards.count != 0){
                getBoards(univ_name: (object?.name)!,board_type:"", board_id: boards[0].board_id,scroll_is: "up")
            }else{
                getBoards(univ_name: (object?.name)!,board_type:"", board_id: 0,scroll_is: "up")
            }
            
        }else{//item == "Review"
            if(boards.count != 0){
                getBoards(univ_name: (object?.name)!,board_type:"Universities Review", board_id: boards[0].board_id,scroll_is: "up")
            }else{
                getBoards(univ_name: (object?.name)!,board_type:"Universities Review", board_id: 0,scroll_is: "up")
            }
            
        }
        refresh.endRefreshing()
    }

    /**
     Handler for when custom Segmented Control changes and will change the
     background color of the view depending on the selection.
     */
    @objc func selectItem(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                item = sender.titleForSegment(at: 0)!
                
                self.tableView.reloadData()
                break
            case 1:
                item = sender.titleForSegment(at: 1)!
                boards.removeAll()
                getBoards(univ_name: (object?.name)!,board_type:"", board_id: 0,scroll_is: "init")
                break
            default:
                item = sender.titleForSegment(at: 2)!
                boards.removeAll()
                getBoards(univ_name: (object?.name)!,board_type:"Universities Review", board_id: 0,scroll_is: "init")
                break
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if(item == "Info"){
            self.tableView.separatorStyle = .none
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityInfoTableViewCell", for: indexPath) as! UniversityInfoTableViewCell
            cell.univRank.text = object?.ranking
            //cell.website.text = object?.website
            cell.website.attributedText = NSAttributedString(string: (object?.website)!, attributes:
                [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
            cell.website.addGestureRecognizer(tapGesture)
            cell.univAddress.text = object?.address
            cell.numberOfStudent.text = object?.num_of_students
            cell.tuition_fee.text = object?.tuition_fee
            cell.sat.text = object?.sat
            cell.act.text = object?.act
//            cell.application_fee.text = object?.application_fee
//            cell.sat_act.text = object?.sat_act
            cell.high_school_gpa.text = object?.high_school_gpa
//            cell.acceptance_rate.text = object?.acceptance_rate
            return cell
            
        }else if(item == "Q&A"){
            
            //cell.titleLabel.text = "University Q&A"
            self.tableView.separatorStyle = .none
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "QandATableViewCell", for: indexPath) as! QandATableViewCell
            
            cell.titleLabel.text = boards[row].board_title
            cell.nicknameLabel.text = boards[row].user_nickname
            cell.detailLabel.text =  boards[row].board_content
            cell.uploadTime.text = CustomizedObject.calculateElapsedTime(created: boards[row].board_created)
            //cell.uploadTime.text = boards[row].board_created
            cell.visitCount.text = String(boards[row].touch_count)
            cell.commentCount.text = String(boards[row].comment_count)
            
            return cell
        }else{//Review
            //cell.titleLabel.text = "University Board"
            self.tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityDetailTableViewCell", for: indexPath) as! UniversityDetailTableViewCell
            
            cell.titleLabel.text = "\(boards[row].board_university)-\(boards[row].board_major)"
            cell.nicknameLabel.text = boards[row].user_nickname
            cell.uploadTime.text = CustomizedObject.calculateElapsedTime(created: boards[row].board_created)
            //cell.uploadTime.text = boards[row].board_created
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
            
            return cell
        }
        //return UITableViewCell()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows : Int = 0
        if(item == "Info"){
            numberOfRows = 1
        }else if(item == "Q&A"){
            numberOfRows = boards.count
        }else{//review
            numberOfRows = boards.count
        }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
        //if Tab is Info, just let user touch
        if(item == "Info"){
            return
        }
        //if Tab is Q&A or Review and user touch but boards.length is 0, let user touch
        if(boards.count == 0){
            return
        }
        
        //check if the board is that I created
        let realm = try! Realm()
        let board_user_id = boards[indexPath.row].user_id
        
        if let user = realm.objects(UserInfo.self).first{
            //if board is that I created,
            if user.user_id == board_user_id{
                
                let alertController = UIAlertController(title: "Caution", message: "It's your post.\nWhat do you want to do?", preferredStyle: .actionSheet)
                let revisionAction = UIAlertAction(title: "Revision", style: .default) { (_) in
                    //need to encode to store customized object into UserDefault
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.boards[indexPath.row])
                    self.userDefault.set(encodedData, forKey: "board")
                    //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
                    self.userDefault.synchronize()
                    self.navigationController?.pushViewController(RevisionMyBoardViewController(), animated: true)
                }
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    //executed when delete button clicked
                    self.deleteMyBoard(board_id: Int64(self.boards[indexPath.row].board_id))
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
                alertController.addAction(revisionAction)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }else{//it is others
                //need to encode to store customized object into UserDefault
                if(item == "Review"){
                    userDefault.set("Universities Review", forKey: "tableName")
                }else{
                    userDefault.set(item, forKey: "tableName")
                }
                
                //update board touch count
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
                                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.boards[indexPath.row])
                                self.userDefault.set(encodedData, forKey: "board")
                                //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
                                self.userDefault.synchronize()
                                self.navigationController?.pushViewController(QandADetailViewController(), animated: true)
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
            }
        }else{
            //else of let user_id = realm.objects(UserInfo.self).first?.user_id
            //do nothing
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat!
        if(item == "Info"){
            //height = UITableViewAutomaticDimension
            height = self.view.frame.size.height
        }
        else if(item == "Q&A"){
            height = 100.0
        }else if(item == "Review"){
            height = 250.0
        }
        return height
        

    }
    
    @objc func tapResponse(_: UITapGestureRecognizer) {
        
        if let url = URL(string: (object?.website)!){
            UIApplication.shared.openURL(url)
        }
    }
}

extension UniversityDetailViewController{
    //helper function to get boards from the server
    //get all the boards of the university
    func getBoards(univ_name:String,board_type:String,board_id:Int,scroll_is:String){
        
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = BoardsRequest()
            //create request
            request.boardId = Int64(board_id)
            request.boardType = board_type
            request.boardUniversity = univ_name
            request.scrollIs = scroll_is
            
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
                        if res?.boardsArray_Count == 0{
                            //self.view.window?.makeToast("No \(self.item) created, yet!", duration: 1.0, position: CSToastPositionBottom)
                        }
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
                    //self.tableView.reloadData()
                }else{
                    self.log.debug("get boards error:\(err)")
                    //self.get_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Boards Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //get_protoCall?.timeout = App.timeout
            //get_protoCall?.start()
            //no need to mention scroll_is == "down"
            //because the data won't be that huge
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
        }
    }
    
    //delete My Board
    func deleteMyBoard(board_id:Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = DeleteMyBoardRequest()
            request.boardId = board_id
            
            GRPC.sharedInstance.authorizedUser.deleteMyBoard(with: request, handler: {
                (res, err) in
                
                if res != nil{
                    //self.delete_protoCall?.finishWithError(nil)
                    self.view.window?.makeToast("Successfully Deleted", duration: 1.0, position: CSToastPositionBottom)
                    
                    if(self.item == "Q&A"){
                        self.boards.removeAll()
                        self.getBoards(univ_name: (self.object?.name)!, board_type: "",board_id: 0,scroll_is: "init")
                    }else{
                        self.boards.removeAll()
                        self.getBoards(univ_name: (self.object?.name)!, board_type: "Universities Review",board_id: 0,scroll_is: "init")
                    }
                    
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
                    self.view.window?.makeToast("Board Touch Error", duration: 1.0, position: CSToastPositionBottom)
                }
                self.view.window?.makeToast("Board Touch", duration: 1.0, position: CSToastPositionTop)
            }
            //GRPC.sharedInstance.rpcCall.cancel()
        })
        
        //touch_protoCall?.timeout = App.timeout
        //touch_protoCall?.start()
    }
}

