//
//  UniversityViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 15..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import Material
import Kingfisher
import PKHUD

class UniversityViewController: UITableViewController{
    
    
    
    var refresh = UIRefreshControl()
    var menuButton: UIBarButtonItem!
    let notificationButton = SSBadgeButton()
    var notificationButtonItem: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var universities = [UniversityObject]()
    let log = XCGLogger.default
    let userDefault = UserDefaults.standard
    var protoCall : GRPCProtoCall?
    let dateFormatter : DateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewCommentNotification), name: NSNotification.Name(rawValue: "newCommentForUnivVC"), object: nil)
        self.navigationItem.title = "University"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        menuButton = UIBarButtonItem(image: Icon.cm.menu,style:.plain, target: self, action: #selector(addTapped))
        
        notificationButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        notificationButton.setImage(UIImage(named: "Notification")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        notificationButton.addTarget(self, action: #selector(addTapped3), for: .touchUpInside)
        notificationButtonItem = UIBarButtonItem(customView: notificationButton)
        
        //notificationButton = UIBarButtonItem(image: Icon.cm.bell,style:.plain, target: self, action: #selector(addTapped3))
        searchButton = UIBarButtonItem(image: Icon.cm.search,style:.plain, target: self, action: #selector(addTapped2))
        
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.rightBarButtonItems = [searchButton,notificationButtonItem]
        self.tableView.delegate = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor.clear
        //refresh control user interaction
        refresh.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.tableView.register(UniversityTableViewCell.self, forCellReuseIdentifier: "UniversityTableViewCell")
        //add refreshControl into tableview
        self.tableView.addSubview(self.refresh)
        //getUniversities
        getUniversities(university_id: 0)
        //every time this view is appeard, check if there is new comment created on me
        checkIfThereIsNewComments(user_id:Int64(userDefault.integer(forKey: "user_id")),date: dateFormatter.string(from: Date()))
        
        
    }
    
    @objc func addTapped(){
        let vc = LeftViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func addTapped2(){
        
        let univSearchController = UnivSearchController()
        //let majorSearchController = MajorSearchController()
        //let mentorSearchController = MentorSearchController()
        let rightViewController = AppTabsController(viewControllers: [univSearchController])
        navigationController?.pushViewController(rightViewController, animated: true)
    }
    
    @objc func addTapped3(){
        //diappear badge when tapped
        notificationButton.badge = nil
        navigationController?.pushViewController(SharedCommentTableViewController(), animated: true)
    }
    
    //show tabbar and hide nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //refreshControl method
    //need to call server to get refresh recently created data when user scroll down tableView
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //refresh method here
        refresh.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityTableViewCell", for: indexPath) as! UniversityTableViewCell
        let row = indexPath.row
        ImageCache.default.retrieveImage(forKey: universities[row].crawling_url, options: nil, completionHandler: {
            (image,cacheType) in
            if let image = image{
                //self.log.debug("image in cache")
                ImageCache.default.store(image, forKey: self.universities[row].crawling_url)
                cell.universityImage.image = image
            }else{
                //self.log.debug("image in server")
                //image is nil, server call
                cell.universityImage.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/universities/\(self.universities[row].crawling_url)"),options: [],completionHandler:{
                    (image, error, cacheType, imageUrl) in
                    //if fails image == nil
                    if(image == nil){
                        cell.universityImage.backgroundColor = UIColor.lightGray
                    }else{
                        cell.universityImage.image = image
                    }
                })
            }
        })
        
        cell.ranking.text = "\(universities[row].ranking)."
        cell.name.text = universities[row].name
        // Check if the last row number is the same as the last current data element to load more boards
        if (row == universities.count-1) {
            log.debug("row:\(row)")
            getUniversities(university_id: universities[universities.count-1].university_id)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        return universities.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        //if the clicked mentor is not myself
        //need to encode to store customized object into UserDefault
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: universities[indexPath.row])
        userDefault.set(encodedData, forKey: "university")
        //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
        userDefault.synchronize()
        navigationController?.pushViewController(UniversityDetailViewController(), animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150.0
    }
    
    deinit {
        
    }
}

extension UniversityViewController{
    //if university_id == 0, init
    //if not, load more
    func getUniversities(university_id : Int){
        if CheckNetworkConnection.isConnectedToNetwork(){
            if(university_id == 0){
                universities.removeAll()
            }
            let request = GetUniversitiesRequest()
            request.universityId = Int64(university_id)
            
            //server call
            GRPC.sharedInstance.authorizedUser.getUniversitiesWith(request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.protoCall?.finishWithError(nil)
                    //database에 불러올 데이터가 없을때 -> 밑에 for 문 에러 방지
                    //조건이 false인 경우에 else문 실행
                    guard (res?.universitiesArray_Count) != 0 else{
                        self.log.debug("UniversitiesArray_count is empty!")
                        return
                    }
                    
                    for i in 0..<Int((res?.universitiesArray_Count)!){
                        let res = res?.universitiesArray.object(at: i) as! University
                        //self.log.debug("res:\(res)")
                        let university = UniversityObject(university_id: Int(res.universityId), name: res.name, ranking: res.ranking, website: res.website, address: res.address, num_of_students: res.numOfStudents, tuition_fee: res.tuitionFee, sat: res.sat, act: res.act, application_fee: res.applicationFee, sat_act: res.satAct, high_school_gpa: res.highSchoolGpa, acceptance_rate: res.acceptanceRate,crawling_url:res.crawlingURL)
                        
                        self.universities.append(university)
                    }
                    self.tableView.reloadData()
                    
                }else{
                    
                    self.log.debug("Get Universites Error:\(err)")
                    //self.protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Universites Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //GRPC.sharedInstance.rpcCall.cancel()
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }
    //check if there is new comments on me based on turning on time of the app
    func checkIfThereIsNewComments(user_id:Int64,date:String){
        
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = CheckIfThereIsNewCommentsRequest()
            request.userId = user_id
            request.date = date
            GRPC.sharedInstance.authorizedUser.checkIfThereIsNewComments(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    self.log.debug("res:\(res?.count)")
                    if res?.count != 0{
                        self.notificationButton.badge = "\((res?.count)!)"
                    }
                }else{
                    self.log.debug("checkIfThereIsNewComments Error:\(err)")
                    if(err != nil){
                        self.view.window?.makeToast("Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    //if there is new comment created, update bell badge
    @objc func handleNewCommentNotification(notification: NSNotification) {
        log.debug("this is MainTabBarVC handleNewCommentNotification")
        notificationButton.badge = "1+"
    }

}





