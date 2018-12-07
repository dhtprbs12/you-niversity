//
//  MentorViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 17..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import RealmSwift
import Kingfisher

class MentorViewController: UITableViewController{
    
    var option: String = "Best"
    var refresh = UIRefreshControl()
    var currentTable: UILabel!
    let log = XCGLogger.default
    let userDefault = UserDefaults.standard
    //array for store mentor object
    var mentors = [MentorObject]()
    let processor = RoundCornerImageProcessor(cornerRadius: 20)
    var check_deleted_protoCall : GRPCProtoCall?
    var touch_protoCall : GRPCProtoCall?
    var get_protoCall : GRPCProtoCall?
    var delete_protoCall : GRPCProtoCall?
    
    override func loadView(){
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.separatorColor = UIColor.clear
        //refresh control user interaction
        refresh.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.tableView.register(MentorTableViewCell.self, forCellReuseIdentifier: "MentorTableViewCell")
        //add refreshControl into tableview
        self.tableView.addSubview(self.refresh)
        //insert label into tableView
        currentTable = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        currentTable.textColor = App.mainColor
        currentTable.font = UIFont.boldSystemFont(ofSize: 20)
        currentTable.textAlignment = .center
        self.tableView.tableHeaderView = currentTable
        
        //when user choose one of the options in FABMenuVC, refresh tableview
        NotificationCenter.default.addObserver(self, selector: #selector(selectOption), name: NSNotification.Name(rawValue: "mentorTable"), object: nil)
        currentTable.text = option
        mentors.removeAll()
        getMentors(mentor_type:option,number_id:0,scroll_is: "init")
    }
    
    //show tabbar and hide nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //check_deleted_protoCall?.finishWithError(nil)
        //get_protoCall?.finishWithError(nil)
        //delete_protoCall?.finishWithError(nil)
    }
    
    func getMentors(mentor_type:String,number_id:Int,scroll_is:String){
        if CheckNetworkConnection.isConnectedToNetwork(){
    
            let request = GetMentorsRequest()
            request.numberId = Int64(number_id)
            request.indicator = mentor_type
            request.scrollIs = scroll_is
            //server call
            GRPC.sharedInstance.authorizedUser.getMentorsWith( request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.get_protoCall?.finishWithError(nil)
                    
                    for i in 0..<Int((res?.mentorsArray_Count)!){
                        let res = res?.mentorsArray.object(at: i) as! Mentor
                        
                        let mentor = MentorObject(number_id:Int(res.numberId),mentor_id:Int(res.mentorId),user_id:Int(res.userId),mentor_nickname:res.mentorNickname,mentor_university:res.mentorUniversity,mentor_major:res.mentorMajor,mentor_backgroundurl:res.mentorBackgroundurl,mentor_profileurl:res.mentorProfileurl,mentor_mentoring_area:res.mentorMentoringArea,mentor_mentoring_field:res.mentorMentoringField,mentor_introduction:res.mentorIntroduction,mentor_information:res.mentorInformation,mentor_touch_count:Int(res.mentorTouchCount),mentor_favorite_count:Int(res.mentorFavoriteCount),mentor_is_active:Int(res.mentorIsActive),mentor_created_at:res.mentorCreatedAt)
                        
                        if(scroll_is == "init" || scroll_is == "down"){
                            self.mentors.append(mentor)
                        }else{
                            //if it is refresh == up
                            //insert it to the front
                            self.mentors.insert(mentor,at:0)
                        }
                    }
                    if(scroll_is == "init"){
                        self.tableView.reloadData()
                    }else if(scroll_is == "up"){
                        if(res?.mentorsArray_Count == 0){
                            //no reload data
                        }else{
                            self.tableView.reloadData()
                        }
                    }else{
                        if(res?.mentorsArray_Count == 0){
                            //no reload data
                        }else{
                            self.tableView.reloadData()
                        }
                    }
                }else{
                    self.log.debug("get mentors \(scroll_is) error:\(err)")
                    //self.get_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Mentor Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //get_protoCall?.timeout = App.timeout
            //get_protoCall?.start()

        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }

    
    
    //notification handler
    @objc func selectOption(notification: NSNotification){
        //load data here
        
        if let selected = notification.userInfo!["option"] as? String {
            if(selected == "Best"){
                
                option = selected
                currentTable.text = option
                mentors.removeAll()
                getMentors(mentor_type: option,number_id:0,scroll_is: "init")
            }else if(selected == "Latest"){
                
                option = selected
                mentors.removeAll()
                getMentors(mentor_type: option,number_id:0,scroll_is: "init")
                currentTable.text = option
                
            }else if(selected == "Wannabe"){
                let realm = try! Realm()
                //if user has registered as a mentor, go to revision VC
                //if not, go to register VC
                if (realm.objects(MentorInfo.self).first == nil){
                    //this is for the updating table
                    userDefault.set(option, forKey: "mentor_option")
                    userDefault.synchronize()
                    let vc = WannaBeMentorViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = MentorRevisionViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                //this is called from MentorSearchController of right view
                option = selected
                if(option == "Search"){
                    let vc = MentorSearchController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    //when user wants find mentors of the university in MentorSearchContoller(),call getMentors()
                    currentTable.text = option
                    mentors.removeAll()
                    getMentors(mentor_type: option,number_id:0,scroll_is: "init")
                }
                
            }
        }
    }
    
    //refreshControl method
    //need to call server to get refresh recently created data when user scroll down tableView
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //refresh method here
        if(mentors.count != 0){
            getMentors(mentor_type: option,number_id:mentors[0].number_id,scroll_is: "up")
        }else{
            getMentors(mentor_type: option,number_id:0,scroll_is: "up")
        }

        refresh.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentorTableViewCell", for: indexPath) as! MentorTableViewCell
        let row = indexPath.row
        //loadImage
        //backgroundImg, profileImg
        //load background image first, then if succeed, load profile image
        self.log.debug("mentor:\(mentors[row].mentor_nickname) -- \(mentors[row].mentor_profileurl)")
        cell.backgroundImage.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(mentors[row].mentor_backgroundurl)"),options:[.processor(processor)],completionHandler:{
            (image, error, cacheType, imageUrl) in
            //if fails image == nil
            if(image == nil){
                cell.backgroundImage.backgroundColor = UIColor.lightGray
            }else{
                cell.backgroundImage.image = image
            }
            
        })
        
        cell.profileImage.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(mentors[row].mentor_profileurl)"),options:[.processor(processor)],completionHandler:{
            (image, error, cacheType, imageUrl) in
            if(image == nil){
                cell.profileImage.image = UIImage(named: "defaultImage")
            }else{
                cell.profileImage.image = image
            }
        })
        cell.name.text = mentors[row].mentor_nickname
        cell.major.text = mentors[row].mentor_major
        cell.universityName.text = mentors[row].mentor_university
        cell.visitCount.text = String(mentors[row].mentor_touch_count)
        cell.favoriteCount.text =
            String(mentors[row].mentor_favorite_count)
        
        //Just need to deal with only timeLabel
        if(option == "Best"){
            //do not show time label
            cell.timeAgo.text = ""
        }else if(option == "Latest"){
            //show time label
            cell.timeAgo.text = mentors[row].mentor_created_at
        }else{
            //wannabe mentor, do nothing
        }
        //if user already clicked a mentor as favorite, show full heart
        if let arr = userDefault.object(forKey: "favoriteMentors") as? [Int]{
            if arr.contains(mentors[row].mentor_id){
                cell.favoriteImage.image = UIImage(named: "ic_favorite_white")
            }else{
                cell.favoriteImage.image = UIImage(named: "outline_favorite_border_white_24dp")
            }
        }else{//if not, show line heart
            cell.favoriteImage.image = UIImage(named: "outline_favorite_border_white_24dp")
        }
        
        // Check if the last row number is the same as the last current data element to load more boards
        if (row == mentors.count-1) {
            //if option == "University Name", do not loadMoreMentors()
            if(option == "Best" || option == "Latest"){
                self.log.debug()
                getMentors(mentor_type: option,number_id:mentors[row].number_id,scroll_is: "down")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /**
         Cancel the image download task bounded to the image view if it is running.
         Nothing will happen if the downloading has already finished.
         */
        cell.imageView?.kf.cancelDownloadTask()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentors.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if mentors.count == 0{
            return
        }
        //if the clicked mentor is not myself
        //check if mentor is deleted
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = CheckIfItsDeletedRequest()
            request.id_p = Int64(mentors[indexPath.row].mentor_id)
            request.type = Int64(2)
            GRPC.sharedInstance.authorizedUser.checkIfItsDeleted(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.check_deleted_protoCall?.finishWithError(nil)
                    if(res?.isDeleted == "true"){
                        self.view.window?.makeToast("The Mentor Just Deleted", duration: 1.5, position: CSToastPositionTop)
                        return
                    }else{
                        
                        //need to encode to store customized object into UserDefault
                        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.mentors[indexPath.row])
                        self.userDefault.set(encodedData, forKey: "mentor")
                        //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
                        self.userDefault.synchronize()
                        
                        let mentorDetailVC = MentorDetailViewController()
                        mentorDetailVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(mentorDetailVC, animated: true)
                        
                        //mentor is not deleted update touch count
                        self.mentorTouch(mentor_id: Int64(self.mentors[indexPath.row].mentor_id))
                    }
                    
                }else{
                    self.log.debug("Check Mentor Deleted Error:\(err)")
                    //self.check_deleted_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Error Occured", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //check_deleted_protoCall?.timeout = App.timeout
            //check_deleted_protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if(mentors[indexPath.row].user_id == userDefault.integer(forKey: "user_id")){
                let alertController = UIAlertController(title: "Caution", message: "Are you sure?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
                let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
                    self.doDelete(mentor_id: self.mentors[indexPath.row].mentor_id,indexPath: indexPath)
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
        return 200.0
    }
}

extension MentorViewController{
    func doDelete(mentor_id:Int,indexPath:IndexPath){
        
        let alertController = UIAlertController(title: "Delete", message: "You sure to delete?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            if CheckNetworkConnection.isConnectedToNetwork(){
                let realm = try! Realm()
                let request = DeleteMentorRequest()
                request.mentorId = Int64(mentor_id)
                
                
                GRPC.sharedInstance.authorizedUser.deleteMentor(with:request, handler:{
                    (res,err) in
                    
                    if res != nil{
                        //self.delete_protoCall?.finishWithError(nil)
                        self.userDefault.removeObject(forKey: "mentor_id")
                        let mentor = realm.objects(MentorInfo.self)
                        
                        try! realm.write {
                            
                            realm.delete(mentor)
                            
                        }
                        self.view.window?.makeToast("Successfully Deleted", duration: 1.0, position: CSToastPositionTop)
                        self.mentors.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        return
                    }else{
                        
                        self.log.debug("Delete Mentor Error: \(err)")
                        //self.delete_protoCall?.finishWithError(err)
                        if(err != nil){
                            self.view.window?.makeToast("Delete Mentor Error", duration: 1.0, position: CSToastPositionBottom)
                        }
                    }
                    //GRPC.sharedInstance.rpcCall.finishWithError(nil)
                })
                //self.delete_protoCall?.timeout = App.timeout
                //self.delete_protoCall?.start()
            }else{
                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func mentorTouch(mentor_id:Int64){
        let request = MentorTouchRequest()
        request.mentorId = mentor_id
        request.indicator = "touch"
        
        GRPC.sharedInstance.authorizedUser.mentorTouch(with: request, handler: {
            (res, err) in
            
            if res != nil{
                //self.touch_protoCall?.finishWithError(nil)
            }else{
                
                self.log.debug("load more mentors error:\(err)")
                //self.touch_protoCall?.finishWithError(err)
                if(err != nil){
                   self.view.window?.makeToast("Touch Mentor Error", duration: 1.0, position: CSToastPositionBottom)
                }
            }
            //GRPC.sharedInstance.rpcCall.cancel()
        })
        
        //touch_protoCall?.timeout = App.timeout
        //touch_protoCall?.start()
    }
}
