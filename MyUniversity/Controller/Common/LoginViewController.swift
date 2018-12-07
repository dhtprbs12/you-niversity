//
//  LoginViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 2..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import RxSwift
import RxCocoa
import PKHUD

class LoginViewController:UIViewController, UITextFieldDelegate,UIScrollViewDelegate{
    
    var scrollView: UIScrollView!
    var tap : UITapGestureRecognizer!
    let userDefault = UserDefaults.standard
    let log = XCGLogger.default
    var loginView : LoginView!
    var protoCall : GRPCProtoCall?
    
    
    override func loadView() {
        super.loadView()
        loginView = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:loginView.bounds.width, height:loginView.bounds.height)
        scrollView.addSubview(loginView)
        self.view.addSubview(scrollView)
        
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.signinButton.rx.tap.subscribe(onNext: { [weak self] x in
            self?.signInBtnTapped()
        }).disposed(by: App.disposeBag)
        loginView.signupButton.rx.tap.subscribe(onNext: { [weak self] x in
            self?.signUpBtnTapped()
        }).disposed(by: App.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        loginView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //키보드 보여질때와 없어질때 실행되는 notification을 탐지해서 그에 해당하는 메소드를 실행
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        protoCall?.finishWithError(nil)
    }
    
    //키보드가 보여질때
    @objc func keyboardDidShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(loginView.emailTextField.frame.origin)) {
                self.scrollView.scrollRectToVisible(loginView.emailTextField.frame, animated: true)
            }
            
        }
    }
    
    //키보드가 없어질때
    @objc func keyboardDidHide(notification:NSNotification){
        let contentInsets : UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func signInBtnTapped(){
        HUD.flash(.progress, delay: 1.0)
        doLogin()
    }
    
    func signUpBtnTapped(){
        
        self.present(RegisterViewController(), animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //nickname
        if textField.returnKeyType == .next {
            
            if textField.text!.trimmed.isEmpty {
                
                loginView.emailTextField.detail = "Please, enter nickname"
                loginView.emailTextField.isErrorRevealed = true
                return false
            }
            
            if isValidNickname(str: (textField.text?.trimmed)!){
                loginView.emailTextField.isErrorRevealed = false
                _ = loginView.passwordTextField.becomeFirstResponder()
                return true
            }else{
                loginView.emailTextField.detail = "Nickname must be more than 5 and less than 15 characters"
                loginView.emailTextField.isErrorRevealed = true
                return false
            }
            
            
        } else {
            if textField.text!.trimmed.isEmpty {
                
                loginView.passwordTextField.detail = "Please, enter password"
                loginView.passwordTextField.isErrorRevealed = true
                return false
            }
            
            if isValidPassword(str: (textField.text?.trimmed)!){
                loginView.passwordTextField.isErrorRevealed = false
                _ = textField.resignFirstResponder()
                HUD.flash(.progress, delay: 1.0)
                doLogin()
                return true
            }else{
                loginView.passwordTextField.detail = "Password must be more than 5 and less than 10 characters"
                loginView.passwordTextField.isErrorRevealed = true
                return false
            }
        }
        
        //return true
    }
    
    func doLogin(){
        
        if loginView.emailTextField.text!.isEmpty {
            
            loginView.emailTextField.detail = "Please, enter nickname"
            loginView.emailTextField.isErrorRevealed = true
            return
        }
        
        if isValidNickname(str: (loginView.emailTextField.text?.trimmed)!) == false{
            loginView.emailTextField.detail = "Nickname must be more than 5 and less than 15 characters"
            loginView.emailTextField.isErrorRevealed = true
            return
        }

        if loginView.passwordTextField.text!.isEmpty {
            loginView.passwordTextField.detail = "Please, enter your password"
            loginView.passwordTextField.isErrorRevealed = true
            return
        }
        
        if isValidPassword(str: (loginView.passwordTextField.text?.trimmed)!) == false{
            loginView.passwordTextField.detail = "Password must be more than 5 and less than 10 characters"
            loginView.passwordTextField.isErrorRevealed = true
            return
        }
        //if it passes all of if statements above
        
        loginView.passwordTextField.isErrorRevealed = false
        loginView.passwordTextField.isErrorRevealed = false
        
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = UserLoginCheckRequest()
            //from here, check error below
            //check the whole stability of thie vc and do same in register e.g. duplicated check
            request.userId = Int64(self.userDefault.integer(forKey: "user_id"))
            request.nickname = loginView.emailTextField.text?.trimmed
            request.password = loginView.passwordTextField.text?.trimmed
            GRPC.sharedInstance.authorizedUser.userLoginCheck(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    if(res?.isInfoCorrect == "true"){
                        self.userDefault.set(true, forKey: "login")
                        self.present(MainTabBarController(), animated: true, completion: nil)
                        HUD.flash(.success, delay: 1.0)
                    }else{
                        self.loginView.emailTextField.detail = "Your nickname does not correct"
                        self.loginView.emailTextField.isErrorRevealed = true
                        self.loginView.passwordTextField.detail = "Your password does not correct"
                        self.loginView.passwordTextField.isErrorRevealed = true
                    }
                }else{
                    self.log.debug("Login Error:\(err)")
                    if(err != nil){
                       self.view.window?.makeToast("Login Error", duration: 1.0, position: CSToastPositionBottom)
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
    
    func isValidPassword(str : String) -> Bool {
        return str.count >= 5 && str.count <= 10
    }
    
    func isValidNickname(str : String) -> Bool {
        return str.count >= 5 && str.count <= 15
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        loginView.emailTextField.isErrorRevealed = false
        loginView.passwordTextField.isErrorRevealed = false
        self.view.endEditing(true)
    }
    deinit {
        log.debug("LoginViewController deinit()")
    }
}
