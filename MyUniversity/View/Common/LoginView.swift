//
//  LoginView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 2..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class LoginView:UIView{
    
    var loginLabel : UILabel!
    var emailTextField: ErrorTextField!
    var passwordTextField: ErrorTextField!
    
    var signinButton: UIButton!
    var signupButton: UIButton!
    
    var parentView: UIView!
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initUI() {
        
        self.backgroundColor = App.mainColor
        
        parentView = UIView().then{
            $0.backgroundColor = UIColor.lightText
            $0.alpha = 1
            $0.contentMode = .scaleToFill
        }
        addSubview(parentView)
        
        parentView.snp.makeConstraints{
            $0.height.equalTo(self.frame.height - 200)
            $0.width.equalTo(270)
            $0.center.equalTo(self.snp.center)
        }
        
        loginLabel = UILabel().then{
            $0.text = "Welcome"
            $0.textColor = UIColor.white
            $0.font = UIFont.boldSystemFont(ofSize: 17)
            
        }
        
        emailTextField = ErrorTextField().then {
            $0.leftView = UIImageView(image:UIImage(named:"ic_person_outline"))
            $0.placeholder = "Nickname"
            $0.detailColor = UIColor.red
            $0.font = RobotoFont.regular(with: 18)
            $0.detailColor = UIColor.red
            $0.borderStyle = .roundedRect
            $0.alpha = 1
            $0.autocorrectionType = .yes
            $0.autocapitalizationType = .none
            $0.returnKeyType = .next
            $0.detailLabel.numberOfLines = 0

        }
        passwordTextField = ErrorTextField().then {
            $0.leftView = UIImageView(image:UIImage(named:"ic_lock_outline"))
            $0.placeholder = "Password"
            $0.detailColor = UIColor.red
            $0.isSecureTextEntry = true
            $0.font = RobotoFont.regular(with: 18)
            $0.borderStyle = .roundedRect
            $0.alpha = 1
            $0.clearButtonMode = .whileEditing
            $0.returnKeyType = .done
            $0.detailLabel.numberOfLines = 0
            
        }
        
        signinButton = RaisedButton(type: .system).then {
            $0.setTitle("Login", for: .normal)
            $0.titleLabel?.font = UIFont(name:"Avenir Next", size:24)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            $0.backgroundColor = UIColor.clear
            //$0.titleLabel?.font = RobotoFont.medium(with: 24)
            $0.titleColor = App.brown
            $0.isMultipleTouchEnabled = false
        }
        
        signupButton = RaisedButton(type: .system).then {
            $0.setTitle("Sign Up", for: .normal)
            //$0.titleLabel?.font = RobotoFont.medium(with: 24)
            $0.backgroundColor = UIColor.clear
            $0.titleColor = App.brown
            $0.isMultipleTouchEnabled = false
        }
        
        parentView.addSubview(loginLabel)
        parentView.addSubview(emailTextField)
        parentView.addSubview(passwordTextField)
    
        parentView.addSubview(signinButton)
        parentView.addSubview(signupButton)
        
        loginLabel.snp.makeConstraints{
            $0.centerX.equalTo(parentView.snp.centerX)
            $0.top.equalTo(parentView.snp.top).offset(20)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(20)
            $0.left.equalTo(parentView).offset(20)
            $0.right.equalTo(parentView).offset(-20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(50)
            $0.left.equalTo(emailTextField)
            $0.right.equalTo(emailTextField)
        }
        
        signinButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20 * 2)
            $0.left.equalTo(emailTextField)
            $0.right.equalTo(emailTextField)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(signinButton.snp.bottom).offset(15)
            $0.left.equalTo(emailTextField)
            $0.right.equalTo(emailTextField)
        }
    }
    
    func dismissKeyboard() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
}
