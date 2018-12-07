//
//  SharedCommentTableViewCell.swift
//  MyUniversity
//
//  Created by 오세균 on 8/22/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material

class SharedCommentTableViewCell: UITableViewCell {
    
    var profile: UIImageView!
    var commentLabel = UILabel()
    var nicknameLabel = UILabel()
    var dividerLabel = UILabel()
    var postedTimeLabel = UILabel()
    
    
    // MARK: Initalizers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        //imageView
        profile = UIImageView().then{
            $0.layer.width = 30
            $0.layer.height = 30
            $0.image = UIImage(named:"defaultImage")
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = $0.frame.size.width / 2;
            $0.layer.borderWidth = 1.0;
            $0.clipsToBounds = true;
        }
        addSubview(profile)
        profile.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.left.equalTo(self.snp.left).offset(3)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        //nicknameLabel
        nicknameLabel = UILabel().then{
            $0.text = "Nickname"
            $0.font = UIFont.boldSystemFont(ofSize: 12)
        }
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.left.equalTo(profile.snp.right).offset(5)
        }
        //dividerLabel
        dividerLabel = UILabel().then{
            $0.text = "|"
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        addSubview(dividerLabel)
        dividerLabel.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel)
            $0.left.equalTo(nicknameLabel.snp.right).offset(2)
        }
        //postedTimeLabel
        postedTimeLabel = UILabel().then{
            $0.text = "2시간 전"
            $0.font = UIFont.systemFont(ofSize: 12)
        }
        addSubview(postedTimeLabel)
        postedTimeLabel.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel)
            $0.left.equalTo(dividerLabel.snp.right).offset(2)
        }
        //comment Label
        commentLabel = UILabel().then{
            $0.text = "This is comment from the user on this board. My name is sekyun Oh majoring CS at University of Arizona. I am testing automatically newline test"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.adjustsFontSizeToFitWidth = true
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 0
        }
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(3)
            //$0.height.equalTo(self.frame.size.height / 2 + 20)
            $0.left.equalTo(nicknameLabel)
            $0.right.equalTo(self.snp.right).offset(-3)
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
