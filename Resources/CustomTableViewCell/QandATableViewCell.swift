//
//  QandATableViewCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 21..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit



class QandATableViewCell: UITableViewCell{
    
    var titleLabel: UILabel!
    var nicknameLabel: UILabel!
    var detailLabel: UILabel!
    var uploadTime: UILabel!
    var visitImage: UIImageView!
    var visitCount: UILabel!
    var commentImage: UIImageView!
    var commentCount: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        //titleLabel
        titleLabel = UILabel().then{
            $0.text = "This is title"
            $0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 1
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(2)
            $0.left.equalTo(self.snp.left).offset(2)
            $0.width.equalTo(self.frame.size.width-70)
        }
        
        //nicknameLabel
        nicknameLabel = UILabel().then{
            $0.text = "nickname"
            $0.textColor = App.mainColor
            $0.font = UIFont.boldSystemFont(ofSize: 14)
        }
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints{
            $0.bottom.equalTo(self.snp.bottom).offset(-2)
            $0.left.equalTo(titleLabel)
        }
        
        //uploadTime
        uploadTime = UILabel().then{
            $0.text = "2018-01-22"
            $0.font = UIFont.systemFont(ofSize: 10)
        }
        addSubview(uploadTime)
        uploadTime.snp.makeConstraints{
            $0.bottom.equalTo(titleLabel)
            $0.right.equalTo(self.snp.right).offset(-2)
        }
        
        //commentCount
        commentCount = UILabel().then{
            $0.text = "10"
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        addSubview(commentCount)
        commentCount.snp.makeConstraints{
            $0.bottom.equalTo(nicknameLabel)
            $0.right.equalTo(uploadTime)
        }
        
        //commentImage
        commentImage = UIImageView().then(){
            $0.image = UIImage(named:"ic_chat_bubble_outline")
            $0.backgroundColor = UIColor.clear
        }
        
        addSubview(commentImage)
        commentImage.snp.makeConstraints{
            $0.bottom.equalTo(nicknameLabel)
            $0.right.equalTo(commentCount.snp.left).offset(-2)
            $0.width.equalTo(14)
            $0.height.equalTo(14)
        }
        
        //visitCount
        visitCount = UILabel().then{
            $0.text = "7"
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        addSubview(visitCount)
        visitCount.snp.makeConstraints{
            $0.bottom.equalTo(nicknameLabel)
            $0.right.equalTo(commentImage.snp.left).offset(-2)
        }
        
        //visitImage
        visitImage = UIImageView().then(){
            $0.image = UIImage(named:"ic_touch_app")
            $0.backgroundColor = UIColor.clear
        }
        
        addSubview(visitImage)
        visitImage.snp.makeConstraints{
            $0.bottom.equalTo(nicknameLabel)
            $0.right.equalTo(visitCount.snp.left).offset(-2)
            $0.width.equalTo(14)
            $0.height.equalTo(14)
        }
        
        //detailLabel
        detailLabel = UILabel().then{
            $0.text = "detailLabel"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 0
        }
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.left.equalTo(titleLabel).offset(5)
            $0.right.equalTo(uploadTime).offset(-5)
            $0.height.equalTo(60)
            //$0.bottom.equalTo(nicknameLabel.snp.top).offset(-3)
            
        }
        
    }
    
}
