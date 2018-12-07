//
//  RegisterViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import Material
import DropDown
import RealmSwift

class RegisterViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
    var scrollView: UIScrollView!
    var registerView: RegisterView!
    var tap : UITapGestureRecognizer!
    let log = XCGLogger.default
    
    //dropdown
    let dropdownage = DropDown()
    let dropdownjob = DropDown()
    
    //User info variables
    var nickname = String()
    var password = String()
    //other
    var userDefault = UserDefaults.standard
    var protoCall : GRPCProtoCall?

    
    override func loadView() {
        super.loadView()
        registerView = RegisterView()
        getServiceManual()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:registerView.bounds.width, height:registerView.bounds.height+registerView.bounds.height + 100)
        scrollView.addSubview(registerView)
        registerView.registerBtn.rx.tap.subscribe({ [weak self] x in
            self?.registerBtnTapped()
        }).disposed(by: App.disposeBag)
        self.view.addSubview(scrollView)
        
        //textfield delegate
        //registerView.email.delegate = self
        registerView.password.delegate = self
        registerView.confirmpwd.delegate = self
        registerView.nickname.delegate = self
        
    }
    
    func getServiceManual(){
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let pathForPrivacy = Bundle.main.path(forResource: "termsfeed-privacy-policy-text-english", ofType: "txt")
                let fileOfPrivacy = try String(contentsOfFile: pathForPrivacy!)
                DispatchQueue.main.async {
                    self.registerView.privacyTextView.text = fileOfPrivacy
                }
                
                let pathForRefund = Bundle.main.path(forResource: "termsfeed-return-refund-policy-text-english", ofType: "txt")
                let fileOfRefund = try String(contentsOfFile: pathForRefund!)
                DispatchQueue.main.async {
                    self.registerView.refundTextView.text = fileOfRefund
                }
                
                let pathForTerms = Bundle.main.path(forResource: "termsfeed-terms-conditions-text-english", ofType: "txt")
                let fileOfTerms = try String(contentsOfFile: pathForTerms!)
                DispatchQueue.main.async {
                    self.registerView.termsTextView.text = fileOfTerms
                }
            } catch {
                self.log.debug("Fatal Error: Couldn't read the contents!")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        registerView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
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
        protoCall?.finishWithError(nil)
    }
    
    //keyboard appear
    @objc func keyboardWillShow(notification:NSNotification){
        
        if let activeField = registerView.nickname, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = textField as? ErrorTextField {
            //nickname, password, confirmpwd
            if textField.returnKeyType == .next {
                if textField.placeholder == "Nickname"{
                    
                    if textField.text!.isEmpty {
                        registerView.nickname.detail = "Write your nickname, please"
                        registerView.nickname.isErrorRevealed = true
                        return false
                    }
                    
                    if isValidNickname(str: (textField.text?.trimmed)!){
                        self.registerView.nickname.isErrorRevealed = false
                        _ = self.registerView.password.becomeFirstResponder()
                        return true
                    }else{
                        registerView.nickname.detail = "Nickname must be more than 5 and less than 15 characters"
                        registerView.nickname.isErrorRevealed = true
                        return false
                    }
                    
                }else if textField.placeholder == "Password"{
                    if textField.text!.isEmpty {
                        
                        registerView.password.detail = "Write your password, please"
                        registerView.password.isErrorRevealed = true
                        return false
                    }
                    
                    if isValidPassword(str: (textField.text?.trimmed)!){
                        registerView.password.isErrorRevealed = false
                        _ = registerView.confirmpwd.becomeFirstResponder()
                        return true
                    }else{
                        registerView.password.detail = "Password must be more than 5 and less than 10 characters"
                        registerView.password.isErrorRevealed = true
                        return false
                    }
                }
            }//end of "textField.returnKeyType == .next"
            else{
                if textField.text!.isEmpty {
                    
                    registerView.confirmpwd.detail = "Confirm your password, please"
                    registerView.confirmpwd.isErrorRevealed = true
                    return false
                }
                
                if registerView.password.text?.trimmed == textField.text?.trimmed {
                    registerView.confirmpwd.isErrorRevealed = false
                    _ = textField.resignFirstResponder()
                    return true
                }else{
                    registerView.confirmpwd.detail = "Please, confirm with password"
                    registerView.confirmpwd.isErrorRevealed = true
                    return false
                }
            }
            
        }//end of "let textField = textField as? ErrorTextField"
        return true
    }
    
    func isValidPassword(str : String) -> Bool {
        return str.count >= 5 && str.count <= 10
    }
    
    func isValidNickname(str : String) -> Bool {
        return str.count >= 5 && str.count <= 15
    }
}

extension RegisterViewController{
    
    func registerBtnTapped(){
        //check one more if user type correctly
        self.view.endEditing(true)
        if (registerView.nickname.text?.isEmpty)!{
            
            registerView.nickname.detail = "Write your nickname, please"
            registerView.nickname.isErrorRevealed = true
            return
        }
        
        if isValidNickname(str: (registerView.nickname.text?.trimmed)!){
            registerView.nickname.isErrorRevealed = false
            
        }else{
            //nickname is not valid
            registerView.nickname.detail = "Nickname must be more than 5 and less than 15 characters"
            registerView.nickname.isErrorRevealed = true
            return
        }
        
        if (registerView.password.text?.isEmpty)!{
            
            registerView.password.detail = "Write your password, please"
            registerView.password.isErrorRevealed = true
            return
            
        }
        
        if isValidNickname(str: (registerView.password.text?.trimmed)!){
            registerView.password.isErrorRevealed = false
        }else{
            registerView.password.detail = "Password must be more than 5 and less than 10 characters"
            registerView.password.isErrorRevealed = true
            return
        }
        
        if (registerView.confirmpwd.text?.trimmed != registerView.password.text?.trimmed){
            
            registerView.confirmpwd.detail = "Correct your password, please"
            registerView.confirmpwd.isErrorRevealed = true
            return
            
        }
        
        //if it passes all of if statements above
        registerView.nickname.isErrorRevealed = false
        registerView.password.isErrorRevealed = false
        registerView.confirmpwd.isErrorRevealed = false

        
        if registerView.agreePrivacySwitch.isOn != true{
            self.view.window?.makeToast("Please, Agree With Our Privacy Policy", duration: 1.0, position: CSToastPositionCenter)
            return
        }
        
        if registerView.agreeRefundSwitch.isOn != true{
            self.view.window?.makeToast("Please, Agree With Our Return & Refund Policy", duration: 1.0, position: CSToastPositionCenter)
            return
        }
        
        if registerView.agreeTermsSwitch.isOn != true{
            self.view.window?.makeToast("Please, Agree With Our Terms & Conditions Policy", duration: 1.0, position: CSToastPositionCenter)
            return
        }
        
        
        nickname = (registerView.nickname.text?.trimmed)!
        password = (registerView.password.text?.trimmed)!
        if CheckNetworkConnection.isConnectedToNetwork(){
            //Register User
            let request = UserRegisterRequest()
            request.nickname = self.nickname
            request.password = self.password
            request.device.deviceCode = (UIDevice.current.identifierForVendor?.uuidString)!
            
            request.device.deviceName = UIDevice.current.modelName
            request.device.os = Device_OS.ios
            request.device.sdkVersion = UIDevice.current.systemVersion
            request.device.appVersion = "1.0-beta"
            //apple token
            request.device.deviceToken = self.userDefault.string(forKey: "deviceToken")
            
            GRPC.sharedInstance.user.userRegistration(with: request, handler: {
                (res, error) in
                
                if res != nil{
                    if res?.isNicknameDuplicated == "false"{
                        
                        self.userDefault.set(true, forKey: "login")
                        self.userDefault.set(Int((res?.userId)!), forKey: "user_id")
                        self.userDefault.set(self.nickname, forKey: "user_nickname")
                        self.userDefault.set((res?.token)!, forKey: "token")
                        DispatchQueue.global(qos: .background).async {
                            let realm = try! Realm()
                            //need to delete all data if user has not been registered. Just in case
                            if realm.objects(UserInfo.self).first != nil{
                                try! realm.write {
                                    realm.deleteAll()
                                }
                            }else{
                                try! realm.write {
                                    let user = UserInfo()
                                    user.user_id = Int((res?.userId)!)
                                    user.nickname = self.nickname
                                    user.password = self.password
                                    user.token = (res?.token)!
                                    user.push = 1
                                    user.coin = 100
                                    realm.create(UserInfo.self, value: user, update: true)
                                }
                            }
                        }
                        
                        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                    }else{
                        
                        self.registerView.nickname.detail = "Nickname Duplicated!"
                        self.registerView.nickname.isErrorRevealed = true
                        return
                    }
                    
                }else{
                    self.log.debug("User Registration Error:\(error)")
                    if(error != nil){
                        self.view.window?.makeToast("User Registration Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //need to cancel request no matter succeeded or failed
                //GRPC.sharedInstance.rpcCall.cancel()
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
            
        }else{
            //if network is not available
            self.view.window?.makeToast("Check Your Network", duration: 1.0, position: CSToastPositionTop)
        }
    }

}
