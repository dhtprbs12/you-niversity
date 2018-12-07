//
//  UniversityTableViewCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 15..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit


class UniversityTableViewCell: UITableViewCell{
    
    var universityImage: UIImageView!
    var name: UILabel!
    var ranking : UILabel!
//    var location: UILabel!
//    var inStateLabel: UILabel!
//    var inStateFee: UILabel!
//    var outStateLabel: UILabel!
//    var outStateFee: UILabel!
//    var numberOfStudent: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        universityImage = UIImageView().then{
            $0.isUserInteractionEnabled = true
            $0.layer.cornerRadius = 5.0
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.white.cgColor
            $0.image = UIImage(named: "stanford")
            $0.clipsToBounds = true
        }
        addSubview(universityImage)
        universityImage.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.width.equalTo(self.snp.width)
            $0.height.equalTo(self.snp.height)
        }
        
        ranking = UILabel().then{
            $0.text = "1."
            $0.textColor = UIColor.white
            //automatically take newline
            //$0.numberOfLines = 0
            //$0.adjustsFontSizeToFitWidth = true
            $0.font = UIFont.boldSystemFont(ofSize: 22)
        }
        addSubview(ranking)
        ranking.snp.makeConstraints{
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        
        name = UILabel().then{
            $0.text = "Name of University"
            $0.textColor = UIColor.white
            //automatically take newline
            $0.numberOfLines = 0
            //$0.adjustsFontSizeToFitWidth = true
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(name)
        name.snp.makeConstraints{
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
            $0.left.equalTo(ranking.snp.right).offset(5)
            //in order to take a newline, should fix width of UILabel
            $0.width.equalTo(self.frame.size.width - 100)
        }        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
