//
//  MentorTableViewCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 18..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit



class MentorTableViewCell: UITableViewCell{
    
    var timeAgo : UILabel!
    var backgroundImage: UIImageView!
    var profileImage: UIImageView!
    var name: UILabel!
    var universityName: UILabel!
    var major: UILabel!
    var visitImage: UIImageView!
    var visitCount: UILabel!
    var favoriteImage: UIImageView!
    var favoriteCount: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        
        timeAgo = UILabel().then{
            $0.text = "1 min ago"
            $0.textColor = UIColor.white
            $0.font = UIFont.boldSystemFont(ofSize: 15)
            
        }
        addSubview(timeAgo)
        timeAgo.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(5)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        self.bringSubview(toFront: timeAgo)
        
        backgroundImage = UIImageView().then{
            
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = UIColor.gray
            //$0.image = UIImage(named:"stanford")
            $0.layer.cornerRadius = 10.0
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.white.cgColor
            
        }
        addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.width.equalTo(self.snp.width)
            $0.height.equalTo(self.snp.height)
        }
        
        //profileImage
        profileImage = UIImageView().then{
            $0.layer.width = 80
            $0.layer.height = 80
            $0.backgroundColor = App.mainColor
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 3
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = $0.frame.size.width / 2;
            $0.clipsToBounds = true;
            $0.image = UIImage(named: "ic_face_white")
            
        }
        addSubview(profileImage)
        profileImage.snp.makeConstraints{
            $0.top.equalTo(backgroundImage).offset(20)
            $0.centerX.equalTo(self.snp.centerX)
            $0.height.equalTo(80)
            $0.width.equalTo(80)
        }
        self.bringSubview(toFront: profileImage)
        //name
        name = UILabel().then{
            $0.text = "My Name"
            $0.textColor = UIColor.white
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            
        }
        addSubview(name)
        name.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.bottom).offset(5)
            $0.centerX.equalTo(profileImage)
        }
        self.bringSubview(toFront: name)
        //major
        major = UILabel().then{
            $0.text = "My Major"
            $0.textColor = UIColor.white
            $0.font = UIFont.boldSystemFont(ofSize: 15)
            
        }
        addSubview(major)
        major.snp.makeConstraints{
            $0.top.equalTo(name.snp.bottom).offset(5)
            $0.centerX.equalTo(profileImage)
        }
        self.bringSubview(toFront: major)
        
        //universityName
        universityName = UILabel().then{
            $0.text = "University Name"
            $0.textColor = UIColor.white
            $0.font = UIFont.boldSystemFont(ofSize: 18)
            
        }
        addSubview(universityName)
        universityName.snp.makeConstraints{
            $0.top.equalTo(major.snp.bottom).offset(3)
            $0.centerX.equalTo(profileImage)
        }
        self.bringSubview(toFront: universityName)
        
        //visitImage
        visitImage = UIImageView().then(){
            $0.image = UIImage(named:"ic_touch_app_white")
            $0.backgroundColor = UIColor.clear
            $0.frame.size = CGSize(width:7, height:7)
            
        }
        
        addSubview(visitImage)
        visitImage.snp.makeConstraints{
            $0.bottom.equalTo(self.snp.bottom).offset(-10)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        self.bringSubview(toFront: visitImage)
        
        //visitCount
        visitCount = UILabel().then(){
            $0.text = "7"
            $0.textColor = UIColor.white
            
        }
        addSubview(visitCount)
        visitCount.snp.makeConstraints{
            $0.bottom.equalTo(visitImage)
            $0.left.equalTo(visitImage.snp.right).offset(5)
        }
        self.bringSubview(toFront: visitCount)
        
        //favoriteCount
        favoriteCount = UILabel().then(){
            $0.text = "14"
            $0.textColor = UIColor.white
            
        }
        addSubview(favoriteCount)
        favoriteCount.snp.makeConstraints{
            $0.bottom.equalTo(visitImage)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        self.bringSubview(toFront: favoriteCount)
        
        //favoriteImage
        favoriteImage = UIImageView().then(){
            $0.image = UIImage(named:"ic_favorite_white")
            $0.backgroundColor = UIColor.clear
            $0.frame.size = CGSize(width:7, height:7)
            
        }
        
        addSubview(favoriteImage)
        favoriteImage.snp.makeConstraints{
            $0.bottom.equalTo(visitImage)
            $0.right.equalTo(favoriteCount.snp.left).offset(-5)
        }
        self.bringSubview(toFront: favoriteImage)
    }
    
}

