//
//  MentorDetailTableViewCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 2. 18..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class MentorDetailTableViewCell: UITableViewCell{
    
    var backgroundImage: UIImageView!
    var headerTextField: UITextField!
    var paragraphTextView: UITextView!


    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundImage = UIImageView().then{
            
            $0.isUserInteractionEnabled = true
            $0.image = UIImage(named:"stanford")
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
        
        //headerTextField
        headerTextField = UITextField().then{
            $0.isUserInteractionEnabled = false
            $0.text = "William Smith"
            $0.textColor = .white
            $0.textAlignment = .center
            $0.sizeToFit()
            
        }
        addSubview(headerTextField)
        headerTextField.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(10)
            $0.centerX.equalTo(self.snp.centerX)
        }
        self.bringSubview(toFront: headerTextField)
        
        //paragraphTextView
        paragraphTextView = UITextView().then{
            $0.text = "This is introduction text view of mentor"
            $0.isUserInteractionEnabled = false
            $0.textColor = .black
            $0.textAlignment = .center
            $0.sizeToFit()
            $0.isScrollEnabled = true
            $0.backgroundColor = .clear
        }
        addSubview(paragraphTextView)
        paragraphTextView.snp.makeConstraints{
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(self.frame.size.width - 50)
            $0.height.equalTo(self.frame.size.height/3)
            $0.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        self.bringSubview(toFront: paragraphTextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
