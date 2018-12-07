//
//  RevisionProfileViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 4. 24..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import Material
import RealmSwift
import DropDown


class RevisionProfileViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
    var scrollView: UIScrollView!
    var revisionProfileView: RevisionProfileView!
    var tap : UITapGestureRecognizer!
    var log = XCGLogger.default
    let userDefault = UserDefaults.standard
    var protoCall : GRPCProtoCall?
    var unregister_protoCall : GRPCProtoCall?
    //dropdown
    let dropdownage = DropDown()
    let dropdownjob = DropDown()
    let dropdownsex = DropDown()
    
    override func loadView() {
        super.loadView()
        revisionProfileView = RevisionProfileView()
        //self.view = RegisterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        //set nav bar
        self.title = "Revision Profile"
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:revisionProfileView.bounds.width, height:revisionProfileView.bounds.height+100)
        scrollView.addSubview(revisionProfileView)
        //targer of buttons
        //age btn
//        revisionProfileView.age.rx.tap.subscribe({ [weak self] x in
//            self?.ageBtnTapped()
//        }).disposed(by: App.disposeBag)
//        //job btn
//        revisionProfileView.job.rx.tap.subscribe({ [weak self] x in
//            self?.jobBtnTapped()
//        }).disposed(by: App.disposeBag)
//        //sex btn
//        revisionProfileView.sex.rx.tap.subscribe({ [weak self] x in
//            self?.sexBtnTapped()
//        }).disposed(by: App.disposeBag)
        //mentor btn
        revisionProfileView.mentor.rx.tap.subscribe({ [weak self] x in
            self?.mentorBtnTapped()
        }).disposed(by: App.disposeBag)
        //save btn
        revisionProfileView.saveBtn.rx.tap.subscribe({ [weak self] x in
            self?.saveBtnTapped()
        }).disposed(by: App.disposeBag)
        //unregister btn
        revisionProfileView.unregisterBtn.rx.tap.subscribe({ [weak self] x in
            self?.unregisterBtnTapped()
        }).disposed(by: App.disposeBag)
        
        self.view.addSubview(scrollView)
        
        //textfield delegate
       
        revisionProfileView.nickname.delegate = self
        
        
        
        //dropdown setting
        //dropdownage
//        dropdownage.anchorView = revisionProfileView.age
//        dropdownage.direction = .bottom
//        dropdownage.backgroundColor = UIColor.white
//        dropdownage.dataSource = ["11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40"]
//
//        // Action triggered on selection
//        dropdownage.selectionAction = { [unowned self] (index, item) in
//            self.revisionProfileView.age.setTitle(item, for: .normal)
//            self.dropdownage.hide()
//        }
//        //dropdownjob
//        dropdownjob.anchorView = revisionProfileView.job
//        dropdownjob.direction = .bottom
//        dropdownjob.backgroundColor = UIColor.white
//        dropdownjob.dataSource = ["Middle","High","Undergraduate","Graduate","Worker"]
//
//        // Action triggered on selection
//        dropdownjob.selectionAction = { [unowned self] (index, item) in
//            self.revisionProfileView.job.setTitle(item, for: .normal)
//            self.dropdownjob.hide()
//            self.view.endEditing(true)
//        }
//        //dropdownsex
//        dropdownsex.anchorView = revisionProfileView.sex
//        dropdownsex.direction = .bottom
//        dropdownsex.backgroundColor = UIColor.white
//        dropdownsex.dataSource = ["Male","Female"]
//
//        // Action triggered on selection
//        dropdownsex.selectionAction = { [unowned self] (index, item) in
//            self.revisionProfileView.sex.setTitle(item, for: .normal)
//            self.dropdownsex.hide()
//            self.view.endEditing(true)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        revisionProfileView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show user info from the realm
        loadUserInfo()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //키보드 보여질때와 없어질때 실행되는 notification을 탐지해서 그에 해당하는 메소드를 실행
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
//        if(self.isMovingToParentViewController){
//            protoCall?.finishWithError(nil)
//            unregister_protoCall?.finishWithError(nil)
//        }
    }
    
    //keyboard appear
    @objc func keyboardWillShow(notification:NSNotification){
        
        if let activeField = revisionProfileView.nickname, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    //keyboard disappear
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInsets : UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func loadUserInfo(){
        let realm = try! Realm()
        //if realm data does exist
        if let obj = realm.objects(UserInfo.self).first{
            revisionProfileView.nickname.text = obj.nickname
        }else{
            //server call
        }
    }
    
//    //age btn
//    func ageBtnTapped(){
//        dropdownage.show()
//    }
//    //job btn
//    func jobBtnTapped(){
//        dropdownjob.show()
//    }
//    //sex btn
//    func sexBtnTapped(){
//        dropdownsex.show()
//    }
    //mentor btn
    func mentorBtnTapped(){
        
        let realm = try! Realm()
        //if user has registered as a mentor, go to revision VC
        //if not, go to register VC
        if (realm.objects(MentorInfo.self).first == nil){
            self.userDefault.set("Revision", forKey: "mentor_option")
            self.userDefault.synchronize()
                self.navigationController?.pushViewController(WannaBeMentorViewController(), animated: true)
        }else{
            self.navigationController?.pushViewController(MentorRevisionViewController(), animated: true)
        }
        
    }
    //save btn
    func saveBtnTapped(){
        self.view.endEditing(true)
        let realm = try! Realm()
        var nickname = String()
        var isChanged : Bool = false
        //check if userinfo exist in realm
        if let obj = realm.objects(UserInfo.self).first{
            //check if user change his/her info
            if (revisionProfileView.nickname.text != obj.nickname){
                isChanged = true
            }
            //update user info
            if isChanged == true{
                
                if CheckNetworkConnection.isConnectedToNetwork(){
                    
                    let request = UpdateProfileRequest()
                    request.userId = Int64(Int(obj.user_id))
                    nickname = (revisionProfileView.nickname.text?.trimmed)!
               
                    request.nickname = nickname
                    request.password = obj.password
                    
                    GRPC.sharedInstance.authorizedUser.updateProfile(with:request, handler:{
                        (res, err) in
                        if res != nil {
                            //self.protoCall?.finishWithError(nil)
                            if(res?.isNicknameDuplicated == "false"){
                                if(res?.isUpdateSucceed == "true"){
                                    //succeed to update in server
                                    self.userDefault.set(nickname, forKey: "user_nickname")
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        let updateUserRealm = try! Realm()
                                        if let user = updateUserRealm.objects(UserInfo.self).first {
                                            try! updateUserRealm.write {
                                                user.nickname = nickname
                                                user.token = (res?.token)!
                                            }
                                        }
                                    }
                                    self.view.window?.makeToast("Successfully Updated", duration: 1.0, position: CSToastPositionBottom)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                }else{
                                    //fail to update in server
                                    self.view.window?.makeToast("Failed to update", duration: 1.0, position: CSToastPositionBottom)
                                }
                            }else{
                                //nickname duplicated
                                self.revisionProfileView.nickname.detail = "Nickname Duplicated!"
                                self.revisionProfileView.nickname.isErrorRevealed = true
                                return
                            }
                            
                        }else{
                            self.log.debug("User Update Error:\(err)")
                            //self.protoCall?.finishWithError(err)
                            if(err != nil){
                                self.view.window?.makeToast("User Update Error", duration: 1.0, position: CSToastPositionBottom)
                            }
                        }
                        //need to cancel request no matter succeeded or failed
                        //GRPC.sharedInstance.rpcCall.cancel()
                    })
                    //protoCall?.timeout = App.timeout
                    //protoCall?.start()
                }else{
                    //if network is not available
                    self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
                }
            }
        }else{
            //if realm doesn't exist in the realm, server call
        }
        isChanged = false
    }
    //unregister btn
    func unregisterBtnTapped(){
        let alertController = UIAlertController(title: "Caution", message: "You sure to unregister?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Unregister", style: .default) { (_) in //confirm button clicked
            
            if CheckNetworkConnection.isConnectedToNetwork(){
                let realm = try! Realm()
                let request = UnregisterRequest()
                request.userId = Int64(self.userDefault.integer(forKey: "user_id"))
               
                GRPC.sharedInstance.authorizedUser.unregister(with: request, handler: {
                    (res,err) in
                    
                    if res != nil{
                        //self.unregister_protoCall?.finishWithError(nil)
                        // Delete all objects from the realm
                        try! realm.write {
                            realm.deleteAll()
                        }
                        
                        exit(0);
                        
                    }else{
                        self.log.debug("Unregister User Error:\(err)")
                        //self.unregister_protoCall?.finishWithError(err)
                        if(err != nil){
                            self.view.window?.makeToast("Unregister User Error", duration: 1.0, position: CSToastPositionBottom)
                        }
                    }
                    //need to cancel request no matter succeeded or failed
                    //GRPC.sharedInstance.rpcCall.cancel()
                })
                //self.unregister_protoCall?.timeout = App.timeout
                //self.unregister_protoCall?.start()
            }else{
                
                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //disappear keyBoard
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let _ = textField as? ErrorTextField {
            
        }
        return false
    }
    
    
}
