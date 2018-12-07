//
//  UniversityDetailTableViewCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 30..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit


class UniversityDetailTableViewCell: UITableViewCell{
    
    var titleLabel: UILabel!
    var nicknameLabel: UILabel!
    var uploadTime: UILabel!
    var visitImage: UIImageView!
    var visitCount: UILabel!
    var commentImage: UIImageView!
    var commentCount: UILabel!
    var detailLabel: UILabel!
    var opinionLabel: UILabel!

    
    
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
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
            $0.lineBreakMode = .byTruncatingTail
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(3)
            $0.left.equalTo(self.snp.left).offset(3)
            $0.width.equalTo(self.frame.size.width - 70)
        }
        
        //nicknameLabel
        nicknameLabel = UILabel().then{
            $0.text = "nickname"
            $0.font = UIFont.boldSystemFont(ofSize: 16)
        }
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleLabel)
        }
        
        //uploadTime
        uploadTime = UILabel().then{
            $0.text = "2018-01-22"
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        addSubview(uploadTime)
        uploadTime.snp.makeConstraints{
            $0.bottom.equalTo(nicknameLabel)
            $0.left.equalTo(nicknameLabel.snp.right).offset(5)
        }
        
        //commentCount
        commentCount = UILabel().then{
            $0.text = "0"
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        addSubview(commentCount)
        commentCount.snp.makeConstraints{
            $0.bottom.equalTo(uploadTime)
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
            $0.right.equalTo(commentCount.snp.left).offset(-5)
            $0.width.equalTo(14)
            $0.height.equalTo(14)
        }
        
        //visitCount
        visitCount = UILabel().then{
            $0.text = "0"
            $0.font = UIFont.systemFont(ofSize: 14)
        }
        addSubview(visitCount)
        visitCount.snp.makeConstraints{
            $0.bottom.equalTo(commentCount)
            $0.right.equalTo(commentImage.snp.left).offset(-5)
        }
        
        //visitImage
        visitImage = UIImageView().then(){
            $0.image = UIImage(named:"ic_touch_app")
            $0.backgroundColor = UIColor.clear
            $0.frame.size = CGSize(width:5, height:5)
            
        }
        
        addSubview(visitImage)
        visitImage.snp.makeConstraints{
            $0.bottom.equalTo(commentCount)
            $0.right.equalTo(visitCount.snp.left).offset(-5)
            $0.width.equalTo(14)
            $0.height.equalTo(14)
        }
        
        detailLabel = UILabel().then(){
            $0.text = "this is detail label"
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.textColor = App.mainColor
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
            //$0.borderWidthPreset = .border1
        }
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleLabel).offset(10)
            $0.right.equalTo(commentCount).offset(-10)
            $0.width.equalTo(self.frame.size.width)
        }
        
        //opinionLabel
        opinionLabel = UILabel().then{ //글자수 맥스 :41
            $0.isUserInteractionEnabled = false
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor.black
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.text = "lksjadflkja;sldkjf;lkasjdf;lksajdf;lkjsdkf;alksjeifj;aowiejf;lsakdjf;laskdjfl;aksdjf;lksdjf;lksadjf;lksjdfiewjfl;iej;lifj;aslkdjf;laisej;fijas;ldkfja;lsiejf;lasijdflkasefjlksdjflkasjdlfjals;kdjfl;askdjfmmmmm"
        }
        addSubview(opinionLabel)
        opinionLabel.snp.makeConstraints{
            
            //top,bottom contraint를 해주고 height값은 설정을 안해줘야 statusLabel lines수대로 tableviewcell height 동적으로 바뀜
            $0.top.equalTo(detailLabel.snp.bottom).offset(3)
            $0.left.equalTo(detailLabel)
            $0.right.equalTo(detailLabel)
            $0.bottom.equalTo(self.snp.bottom).offset(-1)
            //cell's height: 200, half of it: 100
            //$0.height.equalTo(190)
        }
        
        
    }
    
}
