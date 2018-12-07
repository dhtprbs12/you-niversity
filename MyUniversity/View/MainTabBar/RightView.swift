//
//  RightView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 12..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import Material
import Then
import SnapKit

class RightView: UIView{
    var universityTableView: UITableView!
    
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
        self.backgroundColor = UIColor.clear

        
        universityTableView = UITableView(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height))
        addSubview(universityTableView)
        
        
    }
}
