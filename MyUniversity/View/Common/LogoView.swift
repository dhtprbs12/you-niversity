//
//  LogoView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit

class LogoView: UIView {
    
    var logoLabel: UILabel!
    
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
    
    func initUI() {
        
        self.backgroundColor = App.mainColor
        logoLabel = UILabel().then{
            $0.text = "You-niversity"
            $0.textColor = App.brown
            $0.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        }
        addSubview(logoLabel)
        logoLabel.snp.makeConstraints{
            $0.centerY.equalTo(self.snp.centerY)
            $0.centerX.equalTo(self.snp.centerX)
        }
    }
    
}
