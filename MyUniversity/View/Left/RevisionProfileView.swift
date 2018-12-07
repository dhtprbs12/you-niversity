//
//  RevisionProfileView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 4. 24..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class RevisionProfileView: UIView{
    
    //회원정보입력
    //var imageView: UIImageView!
    var nicknameLabel: UILabel!
    var nickname: ErrorTextField! //can be revised
    
    //개인정보입력
//    var ageLabel: UILabel!
//    var age:FlatButton!
//    var jobLabel: UILabel!
//    var job:FlatButton!
//    var sexLabel: UILabel!
//    var sex:FlatButton!
    var mentorLabel: UILabel!
    var mentor:FlatButton!

    //버튼
    var saveBtn: RaisedButton!
    var unregisterBtn: RaisedButton!
    
    
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
        
        //imageView
//        imageView = UIImageView().then{
//            $0.layer.width = 100
//            $0.layer.height = 100
//            //$0.layer.borderWidth = 1.0
//            //$0.layer.borderColor = UIColor.black.cgColor
//            $0.isUserInteractionEnabled = true
//            $0.layer.cornerRadius = $0.frame.size.width / 2
//            $0.clipsToBounds = true
//            $0.image = UIImage(named: "defaultImage")
//
//        }
//        addSubview(imageView)
//        imageView.snp.makeConstraints{
//            $0.top.equalTo(self.snp.top).offset(20)
//            $0.centerX.equalTo(self.snp.centerX)
//            //$0.top.equalTo(mainLabel.snp.bottom).offset(10)
//            //$0.centerX.equalTo(mainLabel)
//            //imageview size크기를 contraint해다 안해주면 이미지 크기가 제멋대로 나옴
//            $0.height.equalTo(100)
//            $0.width.equalTo(100)
//        }
        
        //nickname
        nicknameLabel = UILabel().then{
            $0.text = "Nickname"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(20)
            $0.left.equalTo(self.snp.left).offset(10)
        }
        
        nickname = ErrorTextField().then{
            $0.leftView = UIImageView(image:UIImage(named:"ic_person_outline"))
            $0.text = "sekyunoh"
            $0.textColor = UIColor.black
            $0.borderStyle = .none
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .done
        }
        addSubview(nickname)
        nickname.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            //$0.width.equalTo(self.snp.width)
            $0.left.equalTo(nicknameLabel)
            $0.right.equalTo(self.snp.right).offset(-10)
        }
        
        //age
//        ageLabel = UILabel().then{
//            $0.text = "Age"
//            $0.textColor = App.mainColor
//            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
//            $0.font = UIFont.boldSystemFont(ofSize: 20)
//        }
//        addSubview(ageLabel)
//        ageLabel.snp.makeConstraints{
//            $0.top.equalTo(nickname.snp.bottom).offset(20)
//            $0.left.equalTo(nicknameLabel)
//        }
//
//        age = FlatButton().then{
//            $0.setTitle("Age  ▾", for: .normal)
//            $0.setTitleColor(UIColor.gray, for: .normal)
//            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//            $0.layer.borderWidth = 1
//            $0.borderColor = App.mainColor
//        }
//        addSubview(age)
//        age.snp.makeConstraints{
//            $0.top.equalTo(ageLabel.snp.bottom).offset(10)
//            $0.left.equalTo(nicknameLabel)
//            $0.right.equalTo(self.snp.right).offset(-10)
//        }
//
//        //job
//        jobLabel = UILabel().then{
//            $0.text = "Job"
//            $0.textColor = App.mainColor
//            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
//            $0.font = UIFont.boldSystemFont(ofSize: 20)
//        }
//        addSubview(jobLabel)
//        jobLabel.snp.makeConstraints{
//            $0.top.equalTo(age.snp.bottom).offset(20)
//            $0.left.equalTo(nicknameLabel)
//        }
//
//        job = FlatButton().then{
//            $0.setTitle("Job  ▾", for: .normal)
//            $0.setTitleColor(UIColor.gray, for: .normal)
//            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//            $0.layer.borderWidth = 1
//            $0.borderColor = App.mainColor
//        }
//        addSubview(job)
//        job.snp.makeConstraints{
//            $0.top.equalTo(jobLabel.snp.bottom).offset(10)
//            $0.left.equalTo(nicknameLabel)
//            $0.right.equalTo(self.snp.right).offset(-10)
//        }
//
//        //sex
//        sexLabel = UILabel().then{
//            $0.text = "Sex"
//            $0.textColor = App.mainColor
//            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
//            $0.font = UIFont.boldSystemFont(ofSize: 20)
//        }
//        addSubview(sexLabel)
//        sexLabel.snp.makeConstraints{
//            $0.top.equalTo(job.snp.bottom).offset(20)
//            $0.left.equalTo(nicknameLabel)
//        }
//
//        sex = FlatButton().then{
//            $0.setTitle("Sex  ▾", for: .normal)
//            $0.setTitleColor(UIColor.gray, for: .normal)
//            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
//            $0.layer.borderWidth = 1
//            $0.borderColor = App.mainColor
//        }
//        addSubview(sex)
//        sex.snp.makeConstraints{
//            $0.top.equalTo(sexLabel.snp.bottom).offset(10)
//            $0.left.equalTo(nicknameLabel)
//            $0.right.equalTo(self.snp.right).offset(-10)
//        }
        
        //mentorLabel
        mentorLabel = UILabel().then{
            $0.text = "Mentor"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(mentorLabel)
        mentorLabel.snp.makeConstraints{
            $0.top.equalTo(nickname.snp.bottom).offset(20)
            $0.left.equalTo(nicknameLabel)
        }
        
        //mentorBtn
        mentor = FlatButton().then{
            $0.setTitle("Registration/Revision", for: .normal)
            $0.titleLabel?.numberOfLines = 0
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.setTitleColor(UIColor.gray, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            $0.layer.borderWidth = 1
            $0.borderColor = App.mainColor
        }
        addSubview(mentor)
        mentor.snp.makeConstraints{
            $0.top.equalTo(mentorLabel.snp.bottom).offset(10)
            $0.left.equalTo(nicknameLabel)
            $0.right.equalTo(self.snp.right).offset(-10)
        }
        
        //탈퇴버튼
        unregisterBtn = RaisedButton().then{
            $0.setTitle("Unregister", for: .normal)
            $0.backgroundColor = UIColor.white
            $0.layer.borderWidth = 3
            $0.titleColor = App.mainColor
            $0.borderColor = App.mainColor
        }
        addSubview(unregisterBtn)
        unregisterBtn.snp.makeConstraints{
            $0.top.equalTo(mentor.snp.bottom).offset(20)
            $0.centerX.equalTo(self.snp.centerX)
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
        }
        
        //saveBtn
        saveBtn = RaisedButton().then{
            $0.setTitle("Update", for: .normal)
            $0.backgroundColor = App.mainColor
            $0.titleColor = App.brown
            
        }
        addSubview(saveBtn)
        saveBtn.snp.makeConstraints{
            $0.top.equalTo(unregisterBtn.snp.bottom).offset(10)
            $0.centerX.equalTo(self.snp.centerX)
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            
        }
        
    }
}
