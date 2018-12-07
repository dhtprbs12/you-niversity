//
//  MyUniversityViewController.swift
//  MyUniversity
//
//  Created by 오세균 on 7/25/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import Material
import Kingfisher


class MyUniversityViewController: UITableViewController{
    
    var universities = [UniversityObject]()
    let log = XCGLogger.default
    let userDefault = UserDefaults.standard
    var protoCall : GRPCProtoCall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor.clear
        self.tableView.register(UniversityTableViewCell.self, forCellReuseIdentifier: "UniversityTableViewCell")
        //getMyUniversity based on my scores
        getMyUniversity(university_id: 0, type:userDefault.string(forKey: "sat_act")!,score:userDefault.string(forKey: "score")!,gpa:userDefault.string(forKey: "gpa")!)
        
    }
    
    //show tabbar and hide nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        protoCall?.finishWithError(nil)
//        if(self.isMovingToParentViewController){
//            protoCall?.finishWithError(nil)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityTableViewCell", for: indexPath) as! UniversityTableViewCell
        let row = indexPath.row
        
        cell.universityImage.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/universities/\(universities[row].crawling_url)"),completionHandler:{
            (image, error, cacheType, imageUrl) in
            //if fails image == nil
            if(image == nil){
                cell.universityImage.backgroundColor = UIColor.lightGray
            }else{
                cell.universityImage.image = image
            }
            
        })
        
        //cell.universityImage.image = UIImage(named: "stanford")
        //cell.universityLogo.image = UIImage(named: "stanford")
        cell.ranking.text = "\(universities[row].ranking)."
        cell.name.text = universities[row].name
        // Check if the last row number is the same as the last current data element to load more boards
//        if (row == universities.count-1) {
//            getMyUniversity(university_id: universities[row].university_id, type:userDefault.string(forKey: "sat_act")!,score:userDefault.string(forKey: "score")!,gpa:userDefault.string(forKey: "gpa")!)
//        }
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

extension MyUniversityViewController{
    func getMyUniversity(university_id:Int,type:String,score:String,gpa:String){
        //server call
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetAcceptibleUniversitiesRequest()
            request.universityId = Int64(university_id)
            request.testType = type
            request.score = "\(score)"
            request.gpaScore = "\(gpa)"
            
            GRPC.sharedInstance.authorizedUser.getAcceptibleUniversities(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.protoCall?.finishWithError(nil)
                    //database에 불러올 데이터가 없을때 -> 밑에 for 문 에러 방지
                    //조건이 false인 경우에 else문 실행
                    guard (res?.universitiesArray_Count) != 0 else{
                        self.log.debug("UniversitiesArray_count is empty!")
                        return
                    }
                    if university_id == 0{
                        //init
                        self.universities.removeAll()
                    }else{
                        //more university as user scrolls down
                    }
                    
                    
                    for i in 0..<Int((res?.universitiesArray_Count)!){
                        let res = res?.universitiesArray.object(at: i) as! University
                        let university = UniversityObject(university_id: Int(res.universityId), name: res.name, ranking: res.ranking, website: res.website, address: res.address, num_of_students: res.numOfStudents, tuition_fee: res.tuitionFee, sat: res.sat, act: res.act, application_fee: res.applicationFee, sat_act: res.satAct, high_school_gpa: res.highSchoolGpa, acceptance_rate: res.acceptanceRate,crawling_url:res.crawlingURL)
                        
                        self.universities.append(university)
                    }
                    self.tableView.reloadData()
                }else{
                    self.log.debug("Get Acceptible Universites Error:\(err)")
                    //self.protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Universites Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
            
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
    }

}
