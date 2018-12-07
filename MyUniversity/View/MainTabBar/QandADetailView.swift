//
//  QandADetailView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 29..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class QandADetailView: UIView{
    
    var nickname: UILabel!
    var time: UILabel!
    var title: UILabel!
    var visitImage: UIImageView!
    var visitCount: UILabel!
    var commentImage: UIImageView!
    var commentCount: UILabel!
    var detailTextView: TextView!
    var seeOrReadCommentsLabel : UILabel!
    //var replyTableView: UITableView!
    //var commentTextField: ErrorTextField!
    //var uploadCommentBtn: RaisedButton!
    
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

        //nickname
        nickname = UILabel().then{
            $0.text = "Nickname"
            $0.font = UIFont.boldSystemFont(ofSize: 14)
        }
        addSubview(nickname)
        nickname.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(5)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        
        //time
        time = UILabel().then{
            $0.text = "2018-01-22"
            $0.font = UIFont.systemFont(ofSize: 10)
        }
        addSubview(time)
        time.snp.makeConstraints{
            //$0.centerY.equalTo(nickname)
            $0.bottom.equalTo(nickname)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        //Title
        title = UILabel().then{
            $0.text = "This is the title"
            $0.textColor = App.mainColor
            $0.font = UIFont.boldSystemFont(ofSize: 15)
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        addSubview(title)
        title.snp.makeConstraints{
            $0.top.equalTo(nickname.snp.bottom).offset(10)
            $0.left.equalTo(nickname)
            $0.width.equalTo(self.frame.width - 70)
        }
        
        //commentCount
        commentCount = UILabel().then(){
            $0.text = "0"
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        addSubview(commentCount)
        commentCount.snp.makeConstraints{
            $0.bottom.equalTo(title)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        //commentImage
        commentImage = UIImageView().then(){
            $0.image = UIImage(named:"ic_chat_bubble_outline")
            $0.backgroundColor = UIColor.clear
            
        }
        
        addSubview(commentImage)
        commentImage.snp.makeConstraints{
            $0.bottom.equalTo(commentCount)
            $0.right.equalTo(commentCount.snp.left).offset(-3)
            $0.width.equalTo(15)
            $0.height.equalTo(15)
        }
        
        //visitCount
        visitCount = UILabel().then{
            $0.text = "0"
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        addSubview(visitCount)
        visitCount.snp.makeConstraints{
            $0.bottom.equalTo(title)
            $0.right.equalTo(commentImage.snp.left).offset(-3)
        }
        
        //visitImage
        visitImage = UIImageView().then{
            $0.image = UIImage(named:"ic_touch_app")
            $0.backgroundColor = UIColor.clear
        }
        addSubview(visitImage)
        visitImage.snp.makeConstraints{
            $0.bottom.equalTo(title)
            $0.right.equalTo(visitCount.snp.left).offset(-3)
            $0.width.equalTo(15)
            $0.height.equalTo(15)
        }
        
        //detailTextView
        detailTextView = TextView().then{
            $0.text = "Content"
            $0.isEditable = false
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.textColor = UIColor.black
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 10
            $0.font = UIFont.systemFont(ofSize: 17)
        }
        addSubview(detailTextView)
        detailTextView.snp.makeConstraints{
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.left.equalTo(self.snp.left).offset(3)
            $0.right.equalTo(self.snp.right).offset(-3)
            $0.height.equalTo(self.frame.size.height/2+100)
        }
        
        //seeOrReadCommentsLabel
        seeOrReadCommentsLabel = UILabel().then{
            $0.text = "Tap Here to Read/Post A Comment"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor.lightGray
            $0.textAlignment = .center
            $0.isUserInteractionEnabled = true
        }
        addSubview(seeOrReadCommentsLabel)
        seeOrReadCommentsLabel.snp.makeConstraints{
            $0.top.equalTo(detailTextView.snp.bottom).offset(20)
            $0.left.equalTo(self.snp.left).offset(3)
            $0.right.equalTo(self.snp.right).offset(-3)
        }
        
//        //commentTextField
//        commentTextField = ErrorTextField().then{
//            $0.frame.size = CGSize(width:self.frame.size.width,height:30)
//            $0.isUserInteractionEnabled = true
//            $0.placeholder = "Comment here..."
//            $0.layer.borderWidth = 1
//            $0.layer.cornerRadius = 3
//            $0.returnKeyType = .send
//        }
//        addSubview(commentTextField)
//        commentTextField.snp.makeConstraints{
//            $0.bottom.equalTo(self.snp.bottom)
//            //$0.left.equalTo(detailTextView)
//            //$0.right.equalTo(detailTextView)
//        }
        
        //uploadCommentBtn
//        uploadCommentBtn = RaisedButton(type: .system).then{
//            $0.frame.size = CGSize(width:60,height:30)
//            $0.setTitle("send", for: .normal)
//            $0.isMultipleTouchEnabled = false
//            //$0.backgroundColor = App.mainColor
//            $0.setTitleColor(App.mainColor, for: .normal)
//            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//            //$0.layer.cornerRadius = 2
//        }
//        commentTextField.rightViewMode = .always
//        commentTextField.rightView = uploadCommentBtn
    
//        replyTableView = UITableView()
//        addSubview(replyTableView)
//        replyTableView.snp.makeConstraints{
//            //$0.height.equalTo(250)
//            $0.top.equalTo(detailTextView.snp.bottom).offset(10)
//            $0.left.equalTo(self.snp.left).offset(3)
//            $0.right.equalTo(self.snp.right).offset(-3)
//            $0.bottom.equalTo(self.snp.bottom).offset(-30)
//        }
        
        
    }
    
}
