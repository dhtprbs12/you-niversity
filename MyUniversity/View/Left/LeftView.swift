//
//  LeftView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 12..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material
import PureLayout

class LeftView: UIView{
    
    var upperView: UIView!
    var imageView: UIImageView!
    var editButton : FlatButton!
    var nickname: UILabel!
    var coinLabel: UILabel!
    var coin : UILabel!
    
    var acceptibleUnivBtn : FlatButton!
    var myPageBtn: FlatButton!
    var myUnivReviewBtn: FlatButton!
    var myPostBtn: FlatButton!
    var coinBtn: FlatButton!
    //var attendanceBtn: FlatButton!
    var notificationBtn: FlatButton!
    var reportBtn: FlatButton!
    var logoutBtn:FlatButton!
    
    var shouldSetupConstraints = true
    
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
    
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            
            let edgesInset: CGFloat = 10.0
            let centerOffset: CGFloat = 60.0
            
            upperView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
            
            imageView.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            imageView.autoPinEdge(.bottom, to: .bottom, of: upperView, withOffset: centerOffset)
    
            editButton.autoPinEdge(.left, to: .right, of: imageView, withOffset: edgesInset)
            editButton.autoPinEdge(.bottom, to: .bottom, of: imageView)
            
            nickname.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            nickname.autoPinEdge(.top, to: .bottom, of: imageView, withOffset: edgesInset)
            
//            job.autoPinEdge(.left, to: .right, of: nickname, withOffset: 5)
//            job.autoPinEdge(.bottom, to: .bottom, of: nickname)
//
//            sex.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
//            sex.autoPinEdge(.top, to: .bottom, of: nickname, withOffset: edgesInset-5.0)
            
            coinLabel.autoPinEdge(.left,to: .right,of:nickname, withOffset: edgesInset)
            coinLabel.autoPinEdge(.bottom, to: .bottom, of: nickname)
            
            coin.autoPinEdge(.left,to: .right,of:coinLabel, withOffset: 5.0)
            coin.autoPinEdge(.bottom, to: .bottom, of: coinLabel)
            
            //buttons
            acceptibleUnivBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            acceptibleUnivBtn.autoPinEdge(.top, to: .bottom, of: coin, withOffset: edgesInset+10.0)
            
            myUnivReviewBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            myUnivReviewBtn.autoPinEdge(.top, to: .bottom, of: acceptibleUnivBtn)
            
            myPostBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            myPostBtn.autoPinEdge(.top, to: .bottom, of: myUnivReviewBtn)
            
            coinBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            coinBtn.autoPinEdge(.top, to: .bottom, of: myPostBtn)
//
//            attendanceBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
//            attendanceBtn.autoPinEdge(.top, to: .bottom, of: coinBtn)
            
            notificationBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            notificationBtn.autoPinEdge(.top, to: .bottom, of: coinBtn)
            
            reportBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            reportBtn.autoPinEdge(.top, to: .bottom, of: notificationBtn)
            
            logoutBtn.autoPinEdge(toSuperviewEdge: .left, withInset: edgesInset)
            logoutBtn.autoPinEdge(.top, to: .bottom, of: reportBtn)
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    func initUI(){
        
        upperView = UIView(frame: CGRect.zero)
        upperView.backgroundColor = App.mainColor
        upperView.autoSetDimension(.height, toSize: self.frame.width / 3)
        addSubview(upperView)
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named:"defaultImage")
        imageView.backgroundColor = UIColor.gray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = 5.0
        imageView.autoSetDimension(.width, toSize: 124.0)
        imageView.autoSetDimension(.height, toSize: 124.0)
        addSubview(imageView)
        
        editButton = FlatButton()
        editButton.layer.backgroundColor = UIColor.white.cgColor
        editButton.title = "edit profile"
        editButton.titleColor = App.mainColor
        editButton.layer.borderColor = UIColor.gray.cgColor
        editButton.layer.borderWidth = 1.0
        editButton.layer.cornerRadius = 5.0
        editButton.autoSetDimension(.width, toSize: 100)
        editButton.autoSetDimension(.height, toSize: 30)
        addSubview(editButton)
        
        nickname = UILabel()
        nickname.font = UIFont.boldSystemFont(ofSize: 24)
        nickname.text = "Nickname"
        addSubview(nickname)
        
//        job = UILabel()
//        job.text = "Student"
//        addSubview(job)
//        
//        sex = UILabel()
//        sex.textColor = UIColor.lightGray
//        sex.text = "Male"
//        addSubview(sex)
        
        coinLabel = UILabel()
        coinLabel.textColor = UIColor.lightGray
        coinLabel.text = "coin:"
        addSubview(coinLabel)
        
        coin = UILabel()
        coin.textColor = UIColor.lightGray
        coin.text = "Unlimited"
        addSubview(coin)
        
        acceptibleUnivBtn = FlatButton()
        acceptibleUnivBtn.layer.backgroundColor = UIColor.white.cgColor
        acceptibleUnivBtn.title = "• Find Universities I Can Go"
        acceptibleUnivBtn.titleColor = UIColor.black
        acceptibleUnivBtn.contentHorizontalAlignment = .left
        acceptibleUnivBtn.autoSetDimension(.width, toSize: self.frame.width)
        acceptibleUnivBtn.autoSetDimension(.height, toSize: 50)
        addSubview(acceptibleUnivBtn)
        
        myUnivReviewBtn = FlatButton()
        myUnivReviewBtn.layer.backgroundColor = UIColor.white.cgColor
        myUnivReviewBtn.title = "• My University Review"
        myUnivReviewBtn.titleColor = UIColor.black
        myUnivReviewBtn.contentHorizontalAlignment = .left
        myUnivReviewBtn.autoSetDimension(.width, toSize: self.frame.width)
        myUnivReviewBtn.autoSetDimension(.height, toSize: 50)
        addSubview(myUnivReviewBtn)
        
        myPostBtn = FlatButton()
        myPostBtn.layer.backgroundColor = UIColor.white.cgColor
        myPostBtn.title = "• My Post"
        myPostBtn.titleColor = UIColor.black
        myPostBtn.contentHorizontalAlignment = .left
        myPostBtn.autoSetDimension(.width, toSize: self.frame.width)
        myPostBtn.autoSetDimension(.height, toSize: 50)
        addSubview(myPostBtn)
        
        coinBtn = FlatButton()
        coinBtn.layer.backgroundColor = UIColor.white.cgColor
        coinBtn.title = "• Donation for developer"
        coinBtn.titleLabel?.numberOfLines = 0
        coinBtn.titleColor = UIColor.black
        coinBtn.contentHorizontalAlignment = .left
        coinBtn.autoSetDimension(.width, toSize: self.frame.width)
        coinBtn.autoSetDimension(.height, toSize: 50)
        addSubview(coinBtn)
//
//        attendanceBtn = FlatButton()
//        attendanceBtn.layer.backgroundColor = UIColor.white.cgColor
//        attendanceBtn.title = "• Get 5 coins everyday"
//        attendanceBtn.titleLabel?.numberOfLines = 0
//        attendanceBtn.titleColor = UIColor.black
//        attendanceBtn.contentHorizontalAlignment = .left
//        attendanceBtn.autoSetDimension(.width, toSize: self.frame.width)
//        attendanceBtn.autoSetDimension(.height, toSize: 50)
//        addSubview(attendanceBtn)
        
        notificationBtn = FlatButton()
        notificationBtn.layer.backgroundColor = UIColor.white.cgColor
        notificationBtn.title = "• Notification"
        notificationBtn.titleColor = UIColor.black
        notificationBtn.contentHorizontalAlignment = .left
        notificationBtn.autoSetDimension(.width, toSize: self.frame.width)
        notificationBtn.autoSetDimension(.height, toSize: 50)
        addSubview(notificationBtn)
        
        reportBtn = FlatButton()
        reportBtn.layer.backgroundColor = UIColor.white.cgColor
        reportBtn.title = "• Report"
        reportBtn.titleColor = UIColor.black
        reportBtn.contentHorizontalAlignment = .left
        reportBtn.autoSetDimension(.width, toSize: self.frame.width)
        reportBtn.autoSetDimension(.height, toSize: 50)
        addSubview(reportBtn)
        
        logoutBtn = FlatButton()
        logoutBtn.layer.backgroundColor = UIColor.white.cgColor
        logoutBtn.title = "• Logout"
        logoutBtn.titleColor = UIColor.black
        logoutBtn.contentHorizontalAlignment = .left
        logoutBtn.autoSetDimension(.width, toSize: self.frame.width)
        logoutBtn.autoSetDimension(.height, toSize: 50)
        addSubview(logoutBtn)
        
    }
}
