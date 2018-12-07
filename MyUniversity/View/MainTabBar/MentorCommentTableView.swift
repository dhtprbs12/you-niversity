//
//  MentorCommentTableView.swift
//  MyUniversity
//
//  Created by 오세균 on 8/25/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material
import Then
import SnapKit

class MentorCommentTableView: UIView{
    
    var tableView: UITableView!
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
        
        tableView = UITableView()
        addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.width.equalTo(self.snp.width)
            $0.bottom.equalTo(self.snp.bottom).offset(-30)
        }
        
        
    }
}