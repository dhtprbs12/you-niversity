//
//  RegisterView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class RegisterView: UIView{
    
    //회원가입
    var registerLabel: UILabel!
    
    //회원정보입력
    var memberInfo: UILabel!
    var password:ErrorTextField!
    var confirmpwd:ErrorTextField!
    var nickname: ErrorTextField!
    
    //약관
    var serviceInfo:UILabel!
    var agreePrivacyLabel : UILabel!
    var agreePrivacySwitch : UISwitch!
    var privacyTextView: TextView!
    var agreeRefundLabel : UILabel!
    var agreeRefundSwitch : UISwitch!
    var refundTextView: TextView!
    var agreeTermsLabel : UILabel!
    var agreeTermsSwitch : UISwitch!
    var termsTextView: TextView!
    //회원가입 버튼
    var registerBtn: RaisedButton!
    
    //UIView overrided methods
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
    
    func initUI(){
        self.backgroundColor = UIColor.white
        
        registerLabel = UILabel().then{
            $0.text = "Welcome!"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        }
        addSubview(registerLabel)
        registerLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(10)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        //회원정보입력
        memberInfo = UILabel().then{
            $0.text = "User Information"
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        addSubview(memberInfo)
        memberInfo.snp.makeConstraints{
            $0.top.equalTo(registerLabel.snp.bottom).offset(15)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        
        nickname = ErrorTextField().then{
            $0.leftView = UIImageView(image:UIImage(named:"ic_person_outline"))
            $0.placeholder = "Nickname"
            $0.detailColor = UIColor.red
            $0.borderStyle = .none
            $0.alpha = 1
            $0.clearButtonMode = .whileEditing
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .next
            $0.keyboardType = .alphabet
            $0.detailLabel.numberOfLines = 0
        }
        addSubview(nickname)
        nickname.snp.makeConstraints{
            $0.top.equalTo(memberInfo.snp.bottom).offset(25)
            $0.left.equalTo(memberInfo)
            $0.width.equalTo(self.snp.width)
        }
        
        password = ErrorTextField().then{
            $0.leftView = UIImageView(image:UIImage(named:"ic_lock_outline"))
            $0.placeholder = "Password"
            $0.detailColor = UIColor.red
            $0.isSecureTextEntry = true
            $0.borderStyle = .none
            $0.alpha = 1
            $0.clearButtonMode = .whileEditing
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .next
            $0.detailLabel.numberOfLines = 0
        }
        addSubview(password)
        password.snp.makeConstraints{
            $0.top.equalTo(nickname.snp.bottom).offset(25)
            $0.left.equalTo(memberInfo)
            $0.width.equalTo(nickname)
        }
        
        confirmpwd = ErrorTextField().then{
            $0.leftView = UIImageView(image:UIImage(named:"ic_lock_outline"))
            $0.placeholder = "Confirm password"
            $0.detailColor = UIColor.red
            $0.isSecureTextEntry = true
            $0.borderStyle = .none
            $0.alpha = 1
            $0.clearButtonMode = .whileEditing
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .done
            $0.detailLabel.numberOfLines = 0
        }
        addSubview(confirmpwd)
        confirmpwd.snp.makeConstraints{
            $0.top.equalTo(password.snp.bottom).offset(25)
            $0.left.equalTo(memberInfo)
            $0.width.equalTo(nickname)
        }
        
        //약관
        serviceInfo = UILabel().then{
            $0.text = "Service Information"
            $0.font = UIFont(name:"Avenir Next", size:15)
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        addSubview(serviceInfo)
        serviceInfo.snp.makeConstraints{
            $0.top.equalTo(confirmpwd.snp.bottom).offset(30)
            $0.left.equalTo(memberInfo)
        }
        //privacy
        agreePrivacyLabel = UILabel().then{
            $0.text = "Privacy"
            $0.font = UIFont(name:"Avenir Next", size:15)
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        addSubview(agreePrivacyLabel)
        agreePrivacyLabel.snp.makeConstraints{
            $0.top.equalTo(serviceInfo.snp.bottom).offset(15)
            $0.left.equalTo(memberInfo)
        }
        
        agreePrivacySwitch = UISwitch().then{
            $0.setOn(false, animated: false)
        }
        addSubview(agreePrivacySwitch)
        agreePrivacySwitch.snp.makeConstraints{
            $0.top.equalTo(agreePrivacyLabel)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        //refund
        agreeRefundLabel = UILabel().then{
            $0.text = "Return & Refund"
            $0.font = UIFont(name:"Avenir Next", size:15)
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        addSubview(agreeRefundLabel)
        agreeRefundLabel.snp.makeConstraints{
            $0.top.equalTo(agreePrivacyLabel.snp.bottom).offset(15)
            $0.left.equalTo(memberInfo)
        }
        
        agreeRefundSwitch = UISwitch().then{
            $0.setOn(false, animated: false)
        }
        addSubview(agreeRefundSwitch)
        agreeRefundSwitch.snp.makeConstraints{
            $0.top.equalTo(agreeRefundLabel)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        //terms
        agreeTermsLabel = UILabel().then{
            $0.text = "Terms & Conditions"
            $0.font = UIFont(name:"Avenir Next", size:15)
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        addSubview(agreeTermsLabel)
        agreeTermsLabel.snp.makeConstraints{
            $0.top.equalTo(agreeRefundLabel.snp.bottom).offset(15)
            $0.left.equalTo(memberInfo)
        }
        
        agreeTermsSwitch = UISwitch().then{
            $0.setOn(false, animated: false)
        }
        addSubview(agreeTermsSwitch)
        agreeTermsSwitch.snp.makeConstraints{
            $0.top.equalTo(agreeTermsLabel)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        //회원가입 버튼
        registerBtn = RaisedButton().then{
            $0.setTitle("Register", for: .normal)
            $0.backgroundColor = App.mainColor
            $0.titleColor = App.brown
            $0.isMultipleTouchEnabled = false
        }
        addSubview(registerBtn)
        registerBtn.snp.makeConstraints{
            $0.top.equalTo(agreeTermsLabel.snp.bottom).offset(25)
            $0.left.equalTo(nickname)
            $0.right.equalTo(self.snp.right).offset(-5)
            
        }
        
        //privacy TextView
        privacyTextView = TextView().then{
            $0.isEditable = false
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.textColor = UIColor.black
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
        }
        addSubview(privacyTextView)
        privacyTextView.snp.makeConstraints{
            
            $0.top.equalTo(registerBtn.snp.bottom).offset(25)
            //$0.top.equalTo(serviceInfo.snp.bottom).offset(5)
            $0.left.equalTo(memberInfo)
            $0.right.equalTo(self.snp.right).offset(-5)
            $0.height.equalTo(self.frame.width/2)
            //$0.bottom.equalTo(refundTextView.snp.top).offset(-3)
        }
        //refund TextView
        refundTextView = TextView().then{
            $0.isEditable = false
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.textColor = UIColor.black
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
        }
        addSubview(refundTextView)
        refundTextView.snp.makeConstraints{
            
            $0.top.equalTo(privacyTextView.snp.bottom).offset(25)
            $0.left.equalTo(memberInfo)
            $0.right.equalTo(self.snp.right).offset(-5)
            $0.height.equalTo(self.frame.width/2)
        }
        //terms TextView
        termsTextView = TextView().then{
            //$0.text = "This is serviceTextView"
            $0.isEditable = false
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.textColor = UIColor.black
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
        }
        addSubview(termsTextView)
        termsTextView.snp.makeConstraints{
            
            $0.top.equalTo(refundTextView.snp.bottom).offset(25)
            $0.left.equalTo(memberInfo)
            $0.right.equalTo(self.snp.right).offset(-5)
            $0.height.equalTo(self.frame.width/2)
            //$0.bottom.equalTo(registerBtn.snp.top).offset(-3)
        }
        
        
    }
}
