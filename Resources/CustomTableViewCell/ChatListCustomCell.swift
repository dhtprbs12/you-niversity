//
//  ChatListCustomCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 4. 16..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then

class ChatListCustomCell: UITableViewCell{
    
    var profile: UIImageView!
    var idLabel: UILabel!
    var theLastTextLabel: UILabel!
    var timeLabel:UILabel!
    var messageCounter: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //timeLabel
        timeLabel = UILabel().then{
            $0.text = "2017/03/06"
            $0.textColor = UIColor.black
            $0.font = UIFont.boldSystemFont(ofSize: 13)
            //$0.borderWidthPreset = .border1
        }
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        messageCounter = UILabel().then{
            
            $0.text = "0"
        }
        addSubview(messageCounter)
        messageCounter.snp.makeConstraints{
            $0.centerY.equalTo(self.snp.centerY)
            $0.right.equalTo(self.snp.right).offset(-5)
            
        }
        
//        //idLabel
//        idLabel = UILabel().then{
//            $0.text = "SEKYUNOH"
//            $0.font = UIFont.boldSystemFont(ofSize: 10)
//        }
//        addSubview(idLabel)
//        idLabel.snp.makeConstraints{
//            $0.bottom.equalTo(self.snp.bottom).offset(-3)
//            $0.left.equalTo(self.snp.left).offset(5)
//            //$0.centerX.equalTo(profile.snp.centerX)
//        }

        //imageView
        profile = UIImageView().then{
            $0.layer.width = 60
            $0.layer.height = 60
            $0.image = UIImage(named:"Dan-Leonard")
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = $0.frame.size.width / 2;
            $0.layer.borderWidth = 1.0;
            $0.clipsToBounds = true;
        }
        addSubview(profile)
        profile.snp.makeConstraints{
            $0.top.equalTo(timeLabel.snp.bottom).offset(5)
            $0.left.equalTo(self.snp.left).offset(5)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        //글자수 10 characters
        //idLabel
        idLabel = UILabel().then{
            $0.text = "SEKYUNOH"
            $0.font = UIFont.boldSystemFont(ofSize: 10)
            
        }
        addSubview(idLabel)
        idLabel.snp.makeConstraints{
            //$0.bottom.equalTo(self.snp.bottom).offset(-3)
            $0.top.equalTo(profile.snp.bottom).offset(3)
            $0.centerX.equalTo(profile.snp.centerX)
            //$0.left.equalTo(profile)
        }

        
        //theLastTextLabel
        theLastTextLabel = UILabel().then{
            $0.isUserInteractionEnabled = false
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor.lightGray
            $0.text = "sekunoh"
            //$0.text = "My name is sekyunoh who is majoring in computer science at the university of arizona. Feel free to contact me if you have any concern."
            $0.adjustsFontSizeToFitWidth = true
            $0.numberOfLines = 0
            //$0.borderWidthPreset = .border1

        }
        addSubview(theLastTextLabel)
        theLastTextLabel.snp.makeConstraints{
            $0.top.equalTo(profile)
            $0.left.equalTo(profile.snp.right).offset(5)
            $0.right.equalTo(self.snp.right).offset(-15)
            $0.bottom.equalTo(idLabel.snp.top).offset(-5)
        }
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

