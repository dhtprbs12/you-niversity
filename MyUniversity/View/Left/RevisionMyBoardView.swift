//
//  RevisionMyBoardView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 6. 11..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import Material

class RevisionMyBoardView: UIView{
    
    var universityTextField : TextField!
    var majorTextField : TextField!
    var titleTextField: TextField!
    var textView : TextView!
    var revisionButton: RaisedButton!
    
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    //must be provided by subclass of UIView
    override init(frame: CGRect){
        super.init(frame: frame)
        
        createUI()
    }
    
    //required init(coder:) must be provided by subclass of UIView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createUI() {
        
        self.backgroundColor = UIColor.white
        
        universityTextField = TextField().then{
            $0.tag = 1
            $0.placeholder = "Search the university"
            $0.layer.borderWidth = 1
            $0.spellCheckingType = .no
            $0.returnKeyType = .next
            $0.leftView = UIImageView(image:UIImage(named:"outline_account_balance_black_24pt"))
        }
        addSubview(universityTextField)
        universityTextField.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(30)
            //$0.width.equalTo(self.snp.width)
            $0.left.equalTo(self.snp.left).offset(5)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        majorTextField = TextField().then{
            $0.tag = 2
            $0.placeholder = "Search the major"
            $0.layer.borderWidth = 1
            $0.spellCheckingType = .no
            $0.returnKeyType = .next
            $0.leftView = UIImageView(image:UIImage(named:"outline_school_black_24pt"))
            
        }
        addSubview(majorTextField)
        majorTextField.snp.makeConstraints{
            $0.top.equalTo(universityTextField.snp.bottom).offset(30)
            //$0.width.equalTo(self.snp.width)
            $0.left.equalTo(self.snp.left).offset(5)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        titleTextField = TextField().then{
            $0.tag = 3
            $0.placeholder = "Title, here"
            $0.layer.borderWidth = 1
            $0.returnKeyType = .next
            $0.spellCheckingType = .yes
            
        }
        addSubview(titleTextField)
        titleTextField.snp.makeConstraints{
            $0.top.equalTo(majorTextField.snp.bottom).offset(30)
            //$0.width.equalTo(self.snp.width)
            $0.left.equalTo(self.snp.left).offset(5)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        textView = TextView().then{
            $0.tag = 4
            $0.placeholder = "Content, here"
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.layer.borderWidth = 1
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.spellCheckingType = .yes
            $0.returnKeyType = .done
        }
        addSubview(textView)
        textView.snp.makeConstraints{
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            //$0.width.equalTo(expressTitleTextField)
            $0.left.equalTo(titleTextField)
            $0.right.equalTo(titleTextField)
            $0.height.equalTo(self.frame.size.height / 3)
        }
        
        revisionButton = RaisedButton().then{
            $0.setTitle("Save", for: .normal)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.backgroundColor = App.mainColor
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            $0.isMultipleTouchEnabled = false
        }
        addSubview(revisionButton)
        revisionButton.snp.makeConstraints{
            $0.top.equalTo(textView.snp.bottom).offset(10)
            $0.left.equalTo(titleTextField)
            $0.right.equalTo(titleTextField)
            //$0.width.equalTo(expressTitleTextField)
        }
    }
}

