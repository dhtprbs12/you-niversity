//
//  UniversityDetailView.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 29..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Material

class UniversityDetailView: UIView{
    
    var univBackgroundImage: UIImageView!
    var univLogoImage: UIImageView!
    var univName: UILabel!
    var segmentView: UISegmentedControl!
    var segmentItems = ["Info","Q&A","Review"]
    
    //UIView overrided methods
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        univBackgroundImage = UIImageView()
        univBackgroundImage.image = UIImage(named:"stanford")
        addSubview(univBackgroundImage)
        univBackgroundImage.snp.makeConstraints{
            $0.top.equalTo(self.snp.top)
            $0.width.equalTo(self.snp.width)
            $0.height.equalTo(self.frame.width / 3+20)
        }
        
//        univLogoImage = UIImageView()
//        univLogoImage.backgroundColor = UIColor.gray
//        univLogoImage.layer.borderColor = UIColor.white.cgColor
//        univLogoImage.layer.borderWidth = 1.0
//        univLogoImage.layer.cornerRadius = 5.0
//        addSubview(univLogoImage)
//        univLogoImage.snp.makeConstraints{
//            $0.bottom.equalTo(univBackgroundImage.snp.bottom).offset(-5)
//            $0.width.equalTo(50)
//            $0.height.equalTo(50)
//            $0.left.equalTo(self.snp.left).offset(10)
//        }
        
        univName = UILabel()
        univName.font = UIFont.boldSystemFont(ofSize: 20)
        univName.textColor = UIColor.white
        univName.text = "Univ name"
        univName.numberOfLines = 0
        addSubview(univName)
        univName.snp.makeConstraints{
            $0.bottom.equalTo(univBackgroundImage.snp.bottom).offset(-5)
            $0.left.equalTo(self.snp.left).offset(10)
            $0.width.equalTo(self.frame.size.width - 100)
        }
        
        segmentView = UISegmentedControl(items: segmentItems)
        segmentView.selectedSegmentIndex = 0
        segmentView.backgroundColor = UIColor.white
        segmentView.layer.cornerRadius = 5.0
        //segmentView.frame.size.height = 100
        segmentView.backgroundColor = .clear
        segmentView.tintColor = .clear
        segmentView.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        segmentView.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedStringKey.foregroundColor: App.mainColor
            ], for: .selected)
        //segmentView.layer.borderColor = UIColor.black.cgColor
        segmentView.layer.borderWidth = 0
        addSubview(segmentView)
        segmentView.snp.makeConstraints{
            $0.top.equalTo(univBackgroundImage.snp.bottom).offset(5)
            $0.width.equalTo(self.frame.width)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
