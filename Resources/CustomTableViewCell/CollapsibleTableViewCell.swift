//
//  CollapsibleTableViewCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 3. 22..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material

class CollapsibleTableViewCell: UITableViewCell {
    
    var commentLabel = UILabel()
    var nicknameLabel = UILabel()
    var dividerLabel = UILabel()
    var postedTimeLabel = UILabel()
    var replyButton = FlatButton()
    var numberOfrepliedComments = UILabel()
    
    // MARK: Initalizers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //numberOfrepliedComments
        numberOfrepliedComments = UILabel().then{
            $0.text = "0"
            $0.font = UIFont.boldSystemFont(ofSize: 15)
        }
        addSubview(numberOfrepliedComments)
        numberOfrepliedComments.snp.makeConstraints{
            $0.centerY.equalTo(self.snp.centerY)
            $0.right.equalTo(self.snp.right).offset(-7)
        }
        
        //nicknameLabel
        nicknameLabel = UILabel().then{
            $0.text = "Nickname"
            $0.font = UIFont.boldSystemFont(ofSize: 12)
        }
        addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.left.equalTo(self.snp.left).offset(3)
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
        //replyButton
        replyButton = FlatButton().then{
            $0.setTitle("Reply", for: .normal)
            $0.setTitleColor(UIColor.orange, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }
        addSubview(replyButton)
        replyButton.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel).offset(-7)
            $0.left.equalTo(postedTimeLabel.snp.right).offset(5)
        }
        //comment Label
        commentLabel = UILabel().then{
            $0.text = "This is comment from the user on this board. My name is sekyun Oh majoring CS at University of Arizona. I am testing automatically newline test"
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.adjustsFontSizeToFitWidth = true
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
