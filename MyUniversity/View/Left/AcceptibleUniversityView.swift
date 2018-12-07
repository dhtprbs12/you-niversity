//
//  AcceptibleUniversityView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 6. 14..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class AcceptibleUniversityView:UIView{
    //labels
    var actOrSatSegmentLabel:UILabel!
    var actOrSatScoreTextFieldLabel:UILabel!
    var gpaTextFieldLabel:UILabel!
    let items = ["SAT", "ACT"]
    
    //textfields or others
    var actOrSatSegment:UISegmentedControl!
    var actOrSatScoreTextField:ErrorTextField!
    var gpaTextField:ErrorTextField!
    
    //button
    var findBtn:RaisedButton!
    
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
        //labels
        //actOrSatSegmentLabel
        actOrSatSegmentLabel = UILabel().then{
            $0.text = "SAT/ACT"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(actOrSatSegmentLabel)
        actOrSatSegmentLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(20)
            $0.left.equalTo(self.snp.left).offset(10)
        }
        //actOrSatSegment
        actOrSatSegment = UISegmentedControl(items: items)
        //actOrSatSegment.backgroundColor = .clear
        actOrSatSegment.tintColor = App.mainColor
        actOrSatSegment.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: App.mainColor
            ], for: .normal)
        
        actOrSatSegment.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .selected)
        actOrSatSegment.selectedSegmentIndex = 0
        actOrSatSegment.layer.cornerRadius = 5.0
        actOrSatSegment.frame.size.height = 100
        actOrSatSegment.layer.borderColor = UIColor.black.cgColor
        actOrSatSegment.layer.borderWidth = 1
        addSubview(actOrSatSegment)
        actOrSatSegment.snp.makeConstraints{
            $0.top.equalTo(actOrSatSegmentLabel.snp.bottom).offset(20)
            $0.left.equalTo(actOrSatSegmentLabel)
            $0.right.equalTo(self.snp.right).offset(-10)
        }
        
        //actOrSatScoreTextFieldLabel
        actOrSatScoreTextFieldLabel = UILabel().then{
            $0.text = "Score"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(actOrSatScoreTextFieldLabel)
        actOrSatScoreTextFieldLabel.snp.makeConstraints{
            $0.top.equalTo(actOrSatSegment.snp.bottom).offset(20)
            $0.left.equalTo(actOrSatSegmentLabel)
        }
        //actOrSatScoreTextField
        actOrSatScoreTextField = ErrorTextField().then{
            $0.placeholder = "Please, input your score"
            $0.textColor = UIColor.black
            $0.borderStyle = .none
            $0.autocorrectionType = .no
            $0.keyboardType = .alphabet
            $0.autocapitalizationType = .none
            $0.returnKeyType = .next
        }
        addSubview(actOrSatScoreTextField)
        actOrSatScoreTextField.snp.makeConstraints{
            $0.top.equalTo(actOrSatScoreTextFieldLabel.snp.bottom).offset(23)
            $0.left.equalTo(actOrSatSegmentLabel)
            $0.right.equalTo(self.snp.right).offset(-10)
        }
        //gpaTextFieldLabel
        gpaTextFieldLabel = UILabel().then{
            $0.text = "GPA"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(gpaTextFieldLabel)
        gpaTextFieldLabel.snp.makeConstraints{
            $0.top.equalTo(actOrSatScoreTextField.snp.bottom).offset(20)
            $0.left.equalTo(actOrSatSegmentLabel)
        }
        
        //gpaTextField
        gpaTextField = ErrorTextField().then{
            $0.placeholder = "Please, input your score"
            $0.textColor = UIColor.black
            $0.borderStyle = .none
            $0.autocorrectionType = .no
            $0.keyboardType = .alphabet
            $0.autocapitalizationType = .none
            $0.returnKeyType = .done
        }
        addSubview(gpaTextField)
        gpaTextField.snp.makeConstraints{
            $0.top.equalTo(gpaTextFieldLabel.snp.bottom).offset(23)
            $0.left.equalTo(actOrSatSegmentLabel)
            $0.right.equalTo(self.snp.right).offset(-10)
        }
        //findBtn
        findBtn = RaisedButton().then{
            $0.setTitle("Find", for: .normal)
            $0.backgroundColor = App.mainColor
            $0.titleColor = App.brown
            
        }
        addSubview(findBtn)
        findBtn.snp.makeConstraints{
            $0.top.equalTo(gpaTextField.snp.bottom).offset(20)
            $0.centerX.equalTo(self.snp.centerX)
            $0.left.equalTo(self).offset(10)
            $0.right.equalTo(self).offset(-10)
            
        }
        
    }
    
}
