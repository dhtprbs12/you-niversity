//
//  LeftViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 12..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import Material
import XCGLogger
import RxSwift
import RxCocoa
import RealmSwift

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}


class LeftViewController: UIViewController,UIScrollViewDelegate{

    
    var scrollView: UIScrollView!
    var leftView : LeftView!//scrollView version
    let userDefault = UserDefaults.standard
    let log = XCGLogger.default
    let loginViewController = LoginViewController()
    var report_protoCall : GRPCProtoCall?
    var logout_protoCall : GRPCProtoCall?
    
    override func loadView() {
        super.loadView()
        leftView = LeftView()//scrollView version
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //need to comment below statement when using scrollView
        //self.edgesForExtendedLayout = []
        //self.view = LeftView()
        self.navigationItem.title = "My Info"
        //scrollView setting
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:leftView.bounds.width, height:leftView.bounds.height+100)
        scrollView.addSubview(leftView)
        //buttons' targets
        leftView.editButton.rx.tap.subscribe({ [weak self] x in
            self?.editBtnTapped()
        }).disposed(by: App.disposeBag)
        //acceptibleUnivBtn
        leftView.acceptibleUnivBtn.rx.tap.subscribe({ [weak self] x in
            self?.acceptibleUnivBtnTapped()
        }).disposed(by: App.disposeBag)
        //My University Review button
        leftView.myUnivReviewBtn.rx.tap.subscribe({ [weak self] x in
            self?.myUnivReviewBtnTapped()
        }).disposed(by: App.disposeBag)
        //My post button
        leftView.myPostBtn.rx.tap.subscribe({ [weak self] x in
            self?.myPostBtnTapped()
        }).disposed(by: App.disposeBag)
        //Donation for developer
        leftView.coinBtn.rx.tap.subscribe({ [weak self] x in
            self?.coinBtnBtnTapped()
        }).disposed(by: App.disposeBag)
        //Attendance button
//        leftView.attendanceBtn.rx.tap.subscribe({ [weak self] x in
//            self?.attendanceBtnBtnTapped()
//        }).disposed(by: App.disposeBag)
        //notification btn
        leftView.notificationBtn.rx.tap.subscribe({ [weak self] x in
            self?.notificationBtnTapped()
        }).disposed(by: App.disposeBag)
        //report btn
        leftView.reportBtn.rx.tap.subscribe({ [weak self] x in
            self?.reportBtnTapped()
        }).disposed(by: App.disposeBag)
        //logout btn
        leftView.logoutBtn.rx.tap.subscribe({ [weak self] x in
            self?.logoutBtnTapped()
        }).disposed(by: App.disposeBag)
        self.view.addSubview(scrollView)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        leftView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        loadUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if(self.isMovingToParentViewController){
//            logout_protoCall?.finishWithError(nil)
//            report_protoCall?.finishWithError(nil)
//        }
    }
    
    func loadUserInfo(){
        let realm = try! Realm()
        if let obj = realm.objects(UserInfo.self).first{
            leftView.nickname.text = obj.nickname
//            leftView.job.text = obj.job
//            leftView.sex.text = obj.sex
            //leftView.coin.text = String(obj.coin)
        }else{
            //if there is no userinfo data in the realm, server call
        }
        
        if let mentor = realm.objects(MentorInfo.self).first{
            leftView.imageView.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(mentor.mentor_profile_url)"),options: [],completionHandler:{
                (image, error, cacheType, imageUrl) in
                //if fails image == nil
                if(image == nil){
                    self.leftView.imageView.image = UIImage(named:"defaultImage")
                }else{
                    self.leftView.imageView.image = image
                }
            })
        }
    }
    
    func acceptibleUnivBtnTapped(){
        self.navigationController?.pushViewController(AcceptibleUniversityViewController(), animated: true)
    }
    
    func myUnivReviewBtnTapped(){
        self.navigationController?.pushViewController(MyUniversityReviewController(), animated: true)
    }
    
    func myPostBtnTapped(){
        self.navigationController?.pushViewController(MyPostViewController(), animated: true)
    }
    
    func coinBtnBtnTapped(){
        self.navigationController?.pushViewController(DonationViewController(), animated: true)
    }
    
//    func attendanceBtnBtnTapped(){
//        let realm = try! Realm()
//        let user_id = userDefault.integer(forKey: "user_id")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        let time : TimeZone = TimeZone.ReferenceType.system //시스템 시간대
//        let nowDate : Date = Date(timeIntervalSinceNow:TimeInterval(time.secondsFromGMT())) //로컬 시간
//        let nowString = dateFormatter.string(from: nowDate)
//        //check if user exists in the Realm
//        if let user = realm.objects(UserInfo.self).first{
//            let coin = user.coin
//            if let attendance = realm.objects(Attendance.self).filter("user_id = %@",user_id).first{
//                //그 user_id에 해당하는 attendance_time있으면 비교
//
//                let attendance_date = dateFormatter.date(from: attendance.attendance_time)
//                //출석체크 일부터 오늘까지의 일 수
//                let betweenDays = attendance_date?.daysBetweenDate(toDate: nowDate)
//
//                //if it has been one day after attendance
//                if(betweenDays! >= 1){
//                    try! realm.write {
//                        realm.create(Attendance.self, value:["user_id":user_id,"attendance_time":nowString],update:true)
//                        realm.create(UserInfo.self, value:["user_id":user_id,"coin":coin+5],update:true)
//                    }
//                    self.view.window?.makeToast("5 coin charged!", duration: 1.0, position: CSToastPositionTop)
//                }else{
//                    self.view.window?.makeToast("You've already checked for today", duration: 1.0, position: CSToastPositionTop)
//                }
//            }else{
//                //그 user_id에 해당하는 attendance_time없으면 처음 출첵 -> 베리 지금
//                try! realm.write {
//                    let attendance = Attendance()
//                    attendance.user_id = user_id
//                    attendance.attendance_time = nowString
//                    realm.create(Attendance.self, value: attendance, update: true)
//                    realm.create(UserInfo.self, value:["user_id":user_id,"coin":5],update:true)
//                }
//                self.view.window?.makeToast("5 coin charged!", duration: 1.0, position: CSToastPositionTop)
//            }
//        }else{
//            self.view.window?.makeToast("User does not exists", duration: 1.0, position: CSToastPositionTop)
//        }
//    }
    
    func editBtnTapped(){
        self.navigationController?.pushViewController(RevisionProfileViewController(), animated: true)
    }
    
    //notification btn
    func notificationBtnTapped(){
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    //report btn
    func reportBtnTapped(){
        let alertController = UIAlertController(title: "Report", message: "Please, let us know your issue", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Type within 30 characters"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in //confirm button clicked
            
            if (alertController.textFields?[0]) != nil || !(alertController.textFields?[0].text?.isEmpty)!{
                
                if CheckNetworkConnection.isConnectedToNetwork(){
                    
                    let realm = try! Realm()
                    let request = ReportRequest()
                    request.userId = Int64((realm.objects(UserInfo.self).first?.user_id)!)
                    request.content = alertController.textFields?[0].text
                    GRPC.sharedInstance.authorizedUser.report(with: request, handler: {
                        (res,err) in
                        
                        if res != nil{
                            //self.report_protoCall?.finishWithError(nil)
                            self.view.window?.makeToast("Successfully Accepted, Thanks!", duration: 1.0, position: CSToastPositionBottom)
                            
                        }else{
                            self.log.debug("Report Error:\(err)")
                            //self.report_protoCall?.finishWithError(err)
                            if(err != nil){
                                self.view.window?.makeToast("Report Error", duration: 1.0, position: CSToastPositionBottom)
                            }
                        }
                        //need to cancel request no matter succeeded or failed
                        //GRPC.sharedInstance.rpcCall.cancel()
                    })
                    //self.report_protoCall?.timeout = App.timeout
                    //self.report_protoCall?.start()
                }else{
                    
                    self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
                }
                
            }else{
                //user typed nothing
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //logout btn
    func logoutBtnTapped(){
        let alertController = UIAlertController(title: "Logout", message: "You sure to logout?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Logout", style: .default) { (_) in //confirm button clicked
            
            if CheckNetworkConnection.isConnectedToNetwork(){
                
                let realm = try! Realm()
                let request = LogoutRequest()
                request.userId = Int64((realm.objects(UserInfo.self).first?.user_id)!)
                
                GRPC.sharedInstance.authorizedUser.logout(with: request, handler: {
                    (res,err) in
                    
                    if res != nil{
                        //self.logout_protoCall?.finishWithError(nil)
                        self.userDefault.set(false, forKey: "login")
                        //need to create login view
                        
                        UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
                        
                        
                        
                    }else{
                        self.log.debug("Logout Error:\(err)")
                        //self.logout_protoCall?.finishWithError(err)
                        if(err != nil){
                            self.view.window?.makeToast("Fail to logout", duration: 1.0, position: CSToastPositionBottom)
                        }
                    }
                    //need to cancel request no matter succeeded or failed
                    //GRPC.sharedInstance.rpcCall.cancel()
                })
                //self.logout_protoCall?.timeout = App.timeout
                //self.logout_protoCall?.start()
            }else{
                
                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
            }
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }


}
