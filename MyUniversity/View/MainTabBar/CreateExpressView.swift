//
//  CreateExpressView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 3. 15..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import Material

class CreateExpressView: UIView{
    
    var universityTextField : TextField!
    var majorTextField : TextField!
    var expressTitleTextField: TextField!
    var expressTextView : TextView!
    var expressRegisterButton: RaisedButton!
    
    
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
        
        
        
        expressTitleTextField = TextField().then{
            $0.tag = 3
            $0.placeholder = "Title, here"
            $0.layer.borderWidth = 1
            $0.returnKeyType = .done
            $0.spellCheckingType = .yes
            
        }
        addSubview(expressTitleTextField)
        expressTitleTextField.snp.makeConstraints{
            $0.top.equalTo(majorTextField.snp.bottom).offset(30)
            //$0.width.equalTo(self.snp.width)
            $0.left.equalTo(self.snp.left).offset(5)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        expressTextView = TextView().then{
            $0.tag = 4
            $0.placeholder = "Content, here"
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.layer.borderWidth = 1
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.spellCheckingType = .yes
            $0.returnKeyType = .done
        }
        addSubview(expressTextView)
        expressTextView.snp.makeConstraints{
            $0.top.equalTo(expressTitleTextField.snp.bottom).offset(10)
            //$0.width.equalTo(expressTitleTextField)
            $0.left.equalTo(expressTitleTextField)
            $0.right.equalTo(expressTitleTextField)
            $0.height.equalTo(self.frame.size.height / 3)
        }
        
        expressRegisterButton = RaisedButton().then{
            $0.setTitle("Upload", for: .normal)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.backgroundColor = App.mainColor
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            $0.isMultipleTouchEnabled = false
        }
        addSubview(expressRegisterButton)
        expressRegisterButton.snp.makeConstraints{
            $0.top.equalTo(expressTextView.snp.bottom).offset(10)
            $0.left.equalTo(expressTitleTextField)
            $0.right.equalTo(expressTitleTextField)
            //$0.width.equalTo(expressTitleTextField)
        }        
    }
}
