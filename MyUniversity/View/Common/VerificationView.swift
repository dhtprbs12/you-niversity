//
//  VerificationView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class VerificationView: UIView {
    
    var imageView: UIImageView!
    var textField: ErrorTextField!
    var continueButton : RaisedButton!
    var refreshButton: FlatButton!
    
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
        
        //imageView
        imageView = UIImageView().then{
            $0.layer.borderWidth = 1
        }
        addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(30)
            //imageview size크기를 contraint해다 안해주면 이미지 크기가 제멋대로 나옴
            $0.width.equalTo(self.frame.size.width - 10)
            $0.height.equalTo(60)
            $0.centerX.equalTo(self.snp.centerX)
            
        }
        
        
        
        textField = ErrorTextField().then{
            $0.placeholder = "Enter the verification number"
            $0.placeholderActiveColor = UIColor.black
            $0.textColor = UIColor.black
            $0.detailColor = UIColor.red
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.returnKeyType = .done
            $0.keyboardType = .numberPad
        }
        addSubview(textField)
        textField.snp.makeConstraints{
            //-일수록 위로
            $0.top.equalTo(imageView.snp.bottom).offset(30)
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
        }
        
        continueButton = RaisedButton().then{
            $0.setTitle("Continue", for: .normal)
            $0.backgroundColor = App.mainColor
            $0.titleColor = App.brown
            
        }
        addSubview(continueButton)
        continueButton.snp.makeConstraints{
            $0.top.equalTo(textField.snp.bottom).offset(15)
            $0.centerX.equalTo(self.snp.centerX)
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            
        }
        
        refreshButton = FlatButton().then{
            $0.setTitle("Refresh", for: .normal)
            $0.backgroundColor = UIColor.white
            $0.layer.borderWidth = 3
            $0.titleColor = App.mainColor
            $0.borderColor = App.mainColor
            
        }
        addSubview(refreshButton)
        refreshButton.snp.makeConstraints{
            $0.top.equalTo(continueButton.snp.bottom).offset(10)
            $0.centerX.equalTo(self.snp.centerX)
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            
        }
        
    }
}
