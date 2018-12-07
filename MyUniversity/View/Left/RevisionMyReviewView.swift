//
//  RevisionMyReviewView.swift
//  MyUniversity
//
//  Created by 오세균 on 8/17/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Then
import Material

class RevisionMyReviewView: UIView{
    
    var universityTextField : TextField!
    var majorTextField : TextField!
    var expressShortSummaryLabel : UILabel!
    var expressShortSummaryTextField: TextField!
    var advantageLabel : UILabel!
    var advantageTextView : TextView!
    var disadvantageLabel : UILabel!
    var disadvantageTextView : TextView!
    var briefForTheMenteeLabel : UILabel!
    var briefForTheMenteeTextView : TextView!
    var expressRegisterButton: RaisedButton!
    var maximumCharForExpressField : UILabel!
    var maximumCharForAdvantage : UILabel!
    var maximumCharForDisadvantage : UILabel!
    var maximumCharForBrief : UILabel!
    
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
            $0.placeholder = "Select your university"
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
            $0.placeholder = "Select your major"
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
        
        expressShortSummaryLabel = UILabel().then{
            $0.text = "Summary For This Major"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(expressShortSummaryLabel)
        expressShortSummaryLabel.snp.makeConstraints{
            $0.top.equalTo(majorTextField.snp.bottom).offset(30)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        
        maximumCharForExpressField = UILabel()
        maximumCharForExpressField.textColor = UIColor.red
        maximumCharForExpressField.text = "0/50"
        maximumCharForExpressField.font = UIFont.systemFont(ofSize: 20)
        addSubview(maximumCharForExpressField)
        maximumCharForExpressField.snp.makeConstraints{
            $0.bottom.equalTo(expressShortSummaryLabel)
            $0.left.equalTo(expressShortSummaryLabel.snp.right).offset(10)
        }
        
        expressShortSummaryTextField = TextField().then{
            $0.tag = 3
            $0.placeholder = "Brief summary about department/major\nEx)I would not choose this major. Ex) Welcome to hell"
            $0.layer.borderWidth = 1
            $0.returnKeyType = .done
            $0.spellCheckingType = .yes
            
        }
        addSubview(expressShortSummaryTextField)
        expressShortSummaryTextField.snp.makeConstraints{
            $0.top.equalTo(expressShortSummaryLabel.snp.bottom).offset(30)
            //$0.width.equalTo(self.snp.width)
            $0.left.equalTo(self.snp.left).offset(5)
            $0.right.equalTo(self.snp.right).offset(-5)
        }
        
        advantageLabel = UILabel().then{
            $0.text = "Advantage"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(advantageLabel)
        advantageLabel.snp.makeConstraints{
            $0.top.equalTo(expressShortSummaryTextField.snp.bottom).offset(30)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        
        maximumCharForAdvantage = UILabel()
        maximumCharForAdvantage.textColor = UIColor.red
        maximumCharForAdvantage.text = "0/1000"
        maximumCharForAdvantage.font = UIFont.systemFont(ofSize: 20)
        addSubview(maximumCharForAdvantage)
        maximumCharForAdvantage.snp.makeConstraints{
            $0.bottom.equalTo(advantageLabel)
            $0.left.equalTo(advantageLabel.snp.right).offset(10)
        }
        
        advantageTextView = TextView().then{
            $0.placeholder = "Briefly, describe advantage of this major. MAX:1000 characters"
            $0.tag = 4
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.layer.borderWidth = 1
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.spellCheckingType = .yes
            $0.returnKeyType = .next
        }
        addSubview(advantageTextView)
        advantageTextView.snp.makeConstraints{
            $0.top.equalTo(advantageLabel.snp.bottom).offset(5)
            //$0.width.equalTo(expressTitleTextField)
            $0.left.equalTo(expressShortSummaryTextField)
            $0.right.equalTo(expressShortSummaryTextField)
            $0.height.equalTo(self.frame.size.width / 3)
        }
        
        disadvantageLabel = UILabel().then{
            $0.text = "Disdvantage"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(disadvantageLabel)
        disadvantageLabel.snp.makeConstraints{
            $0.top.equalTo(advantageTextView.snp.bottom).offset(30)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        
        maximumCharForDisadvantage = UILabel()
        maximumCharForDisadvantage.textColor = UIColor.red
        maximumCharForDisadvantage.text = "0/1000"
        maximumCharForDisadvantage.font = UIFont.systemFont(ofSize: 20)
        addSubview(maximumCharForDisadvantage)
        maximumCharForDisadvantage.snp.makeConstraints{
            $0.bottom.equalTo(disadvantageLabel)
            $0.left.equalTo(disadvantageLabel.snp.right).offset(10)
        }
        
        disadvantageTextView = TextView().then{
            $0.placeholder = "Briefly, describe disadvantage of this major. MAX:1000 characters"
            $0.tag = 5
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.layer.borderWidth = 1
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.spellCheckingType = .yes
            $0.returnKeyType = .next
        }
        addSubview(disadvantageTextView)
        disadvantageTextView.snp.makeConstraints{
            $0.top.equalTo(disadvantageLabel.snp.bottom).offset(5)
            //$0.width.equalTo(expressTitleTextField)
            $0.left.equalTo(expressShortSummaryTextField)
            $0.right.equalTo(expressShortSummaryTextField)
            $0.height.equalTo(self.frame.size.width / 3)
        }
        
        briefForTheMenteeLabel = UILabel().then{
            $0.text = "What do you want to say?"
            $0.textColor = App.mainColor
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        addSubview(briefForTheMenteeLabel)
        briefForTheMenteeLabel.snp.makeConstraints{
            $0.top.equalTo(disadvantageTextView.snp.bottom).offset(30)
            $0.left.equalTo(self.snp.left).offset(5)
        }
        
        maximumCharForBrief = UILabel()
        maximumCharForBrief.textColor = UIColor.red
        maximumCharForBrief.text = "0/1000"
        maximumCharForBrief.font = UIFont.systemFont(ofSize: 20)
        addSubview(maximumCharForBrief)
        maximumCharForBrief.snp.makeConstraints{
            $0.bottom.equalTo(briefForTheMenteeLabel)
            $0.left.equalTo(briefForTheMenteeLabel.snp.right).offset(10)
        }
        
        briefForTheMenteeTextView = TextView().then{
            $0.placeholder = "Briefly, mention for students in advance. MAX:1000 characters"
            $0.tag = 6
            $0.isScrollEnabled = true
            $0.isUserInteractionEnabled = true
            $0.layer.borderWidth = 1
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.spellCheckingType = .yes
            $0.returnKeyType = .done
        }
        addSubview(briefForTheMenteeTextView)
        briefForTheMenteeTextView.snp.makeConstraints{
            $0.top.equalTo(briefForTheMenteeLabel.snp.bottom).offset(5)
            //$0.width.equalTo(expressTitleTextField)
            $0.left.equalTo(expressShortSummaryTextField)
            $0.right.equalTo(expressShortSummaryTextField)
            $0.height.equalTo(self.frame.size.width / 3)
        }
        
        expressRegisterButton = RaisedButton().then{
            $0.setTitle("Revise", for: .normal)
            $0.setTitleColor(UIColor.white, for: .normal)
            $0.backgroundColor = App.mainColor
            $0.layer.cornerRadius = 5
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            $0.isMultipleTouchEnabled = false
        }
        addSubview(expressRegisterButton)
        expressRegisterButton.snp.makeConstraints{
            $0.top.equalTo(briefForTheMenteeTextView.snp.bottom).offset(10)
            $0.left.equalTo(expressShortSummaryTextField)
            $0.right.equalTo(expressShortSummaryTextField)
            //$0.width.equalTo(expressTitleTextField)
        }
    }
}
