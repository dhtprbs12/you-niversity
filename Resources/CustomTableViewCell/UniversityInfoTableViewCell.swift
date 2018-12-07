//
//  UniversityInfoTableViewCell.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 4. 24..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit


class UniversityInfoTableViewCell: UITableViewCell{

    var univRankLabel: UILabel!
    var univRank: UILabel!
    var websiteLabel: UILabel!
    var website: UILabel!
    var univAddressLabel:UILabel!
    var univAddress: UILabel!
    var numberOfStudentLabel: UILabel!
    var numberOfStudent: UILabel!
    
    var tuition_fee_label: UILabel!
    var tuition_fee: UILabel!
    var sat_label: UILabel!
    var sat: UILabel!
    var act_label: UILabel!
    var act: UILabel!
//    var application_fee_label: UILabel!
//    var application_fee: UILabel!
//    var sat_act_label: UILabel!
//    var sat_act: UILabel!
    var high_school_gpa_label: UILabel!
    var high_school_gpa: UILabel!
//    var acceptance_rate_label: UILabel!
//    var acceptance_rate: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        univRankLabel = UILabel()
        univRankLabel.font = UIFont.boldSystemFont(ofSize: 30)
        univRankLabel.text = "Rank"
        self.addSubview(univRankLabel)
        univRankLabel.snp.makeConstraints{
            $0.top.equalTo(self.snp.top).offset(20)
            $0.left.equalTo(self.snp.left).offset(10)
        }
        
        univRank = UILabel()
        univRank.font = UIFont.boldSystemFont(ofSize: 30)
        univRank.textColor = UIColor.orange
        univRank.text = "1th"
        self.addSubview(univRank)
        univRank.snp.makeConstraints{
            $0.top.equalTo(univRankLabel)
            $0.left.equalTo(univRankLabel.snp.right).offset(10)
        }
        
        websiteLabel = UILabel()
        websiteLabel.font = UIFont.boldSystemFont(ofSize: 15)
        websiteLabel.text = "Website"
        self.addSubview(websiteLabel)
        websiteLabel.snp.makeConstraints{
            $0.top.equalTo(univRankLabel.snp.bottom).offset(20)
            $0.left.equalTo(univRankLabel)
            
        }
        
        website = UILabel()
        website.text = "www.google.com"
        website.textColor = UIColor.blue
        website.font = UIFont.systemFont(ofSize: 13)
        website.numberOfLines = 0
        website.isUserInteractionEnabled = true
        self.addSubview(website)
        website.snp.makeConstraints{
            $0.top.equalTo(websiteLabel)
            $0.left.equalTo(websiteLabel.snp.right).offset(10)
            $0.width.equalTo(self.frame.width-100)
        }
        
        univAddressLabel = UILabel()
        univAddressLabel.font = UIFont.boldSystemFont(ofSize: 15)
        univAddressLabel.text = "Address"
        
        self.addSubview(univAddressLabel)
        univAddressLabel.snp.makeConstraints{
            $0.top.equalTo(websiteLabel.snp.bottom).offset(20)
            $0.left.equalTo(univRankLabel)
        }
        
        
        univAddress = UILabel()
        //in order to take a newline, should fix width of UILabel
        //univAddress.autoSetDimension(.width, toSize: self.frame.width/2)
        univAddress.lineBreakMode = .byWordWrapping
        univAddress.numberOfLines = 0
        univAddress.text = "1010 e mable st, tucson, AZ, 85719 my name is sekyun oh. Hello, How are you?"
        univAddress.textColor = UIColor.lightGray
        univAddress.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(univAddress)
        univAddress.snp.makeConstraints{
            $0.top.equalTo(univAddressLabel)
            $0.width.equalTo(self.frame.width/2)
            $0.left.equalTo(univAddressLabel.snp.right).offset(10)
        }
        
        numberOfStudentLabel = UILabel()
        numberOfStudentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        numberOfStudentLabel.text = "Student #"
        self.addSubview(numberOfStudentLabel)
        numberOfStudentLabel.snp.makeConstraints{
            $0.top.equalTo(univAddress.snp.bottom).offset(20)
            $0.left.equalTo(univRankLabel)
        }
        
        numberOfStudent = UILabel()
        numberOfStudent.text = "30,000"
        numberOfStudent.textColor = UIColor.lightGray
        numberOfStudent.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(numberOfStudent)
        numberOfStudent.snp.makeConstraints{
            $0.top.equalTo(numberOfStudentLabel)
            $0.left.equalTo(numberOfStudentLabel.snp.right).offset(10)
        }
        
        tuition_fee_label = UILabel()
        tuition_fee_label.font = UIFont.boldSystemFont(ofSize: 15)
        tuition_fee_label.text = "Tuition Fee"
        self.addSubview(tuition_fee_label)
        tuition_fee_label.snp.makeConstraints{
            $0.top.equalTo(numberOfStudentLabel.snp.bottom).offset(20)
            $0.left.equalTo(univRankLabel)
        }
        
        tuition_fee = UILabel()
        tuition_fee.text = "$80,000"
        tuition_fee.textColor = UIColor.lightGray
        tuition_fee.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(tuition_fee)
        tuition_fee.snp.makeConstraints{
            $0.top.equalTo(tuition_fee_label)
            $0.left.equalTo(tuition_fee_label.snp.right).offset(10)
        }
        
        sat_label = UILabel()
        sat_label.font = UIFont.boldSystemFont(ofSize: 15)
        sat_label.text = "SAT"
        self.addSubview(sat_label)
        sat_label.snp.makeConstraints{
            $0.top.equalTo(tuition_fee_label.snp.bottom).offset(20)
            $0.left.equalTo(univRankLabel)
        }
        
        sat = UILabel()
        sat.text = "250"
        sat.textColor = UIColor.lightGray
        sat.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(sat)
        sat.snp.makeConstraints{
            $0.top.equalTo(sat_label)
            $0.left.equalTo(sat_label.snp.right).offset(10)
        }
        
        act_label = UILabel()
        act_label.font = UIFont.boldSystemFont(ofSize: 15)
        act_label.text = "ACT"
        self.addSubview(act_label)
        act_label.snp.makeConstraints{
            $0.top.equalTo(sat_label.snp.bottom).offset(20)
            $0.left.equalTo(univRankLabel)
        }
        
        act = UILabel()
        act.text = "35"
        act.textColor = UIColor.lightGray
        act.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(act)
        act.snp.makeConstraints{
            $0.top.equalTo(act_label)
            $0.left.equalTo(act_label.snp.right).offset(10)
        }
        
        high_school_gpa_label = UILabel()
        high_school_gpa_label.font = UIFont.boldSystemFont(ofSize: 15)
        high_school_gpa_label.text = "High School GPA"
        self.addSubview(high_school_gpa_label)
        high_school_gpa_label.snp.makeConstraints{
            $0.top.equalTo(act_label.snp.bottom).offset(20)
            $0.left.equalTo(univRankLabel)
        }
        
        high_school_gpa = UILabel()
        high_school_gpa.text = ""
        high_school_gpa.textColor = UIColor.lightGray
        high_school_gpa.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(high_school_gpa)
        high_school_gpa.snp.makeConstraints{
            $0.top.equalTo(high_school_gpa_label)
            $0.left.equalTo(high_school_gpa_label.snp.right).offset(10)
        }

        
//        application_fee_label = UILabel()
//        application_fee_label.font = UIFont.boldSystemFont(ofSize: 15)
//        application_fee_label.text = "Application Fee"
//        self.addSubview(application_fee_label)
//        application_fee_label.snp.makeConstraints{
//            $0.top.equalTo(act_label.snp.bottom).offset(20)
//            $0.left.equalTo(univRankLabel)
//        }
//
//        application_fee = UILabel()
//        application_fee.text = "$25"
//        application_fee.textColor = UIColor.lightGray
//        application_fee.font = UIFont.boldSystemFont(ofSize: 15)
//        self.addSubview(application_fee)
//        application_fee.snp.makeConstraints{
//            $0.top.equalTo(application_fee_label)
//            $0.left.equalTo(application_fee_label.snp.right).offset(10)
//        }
//
//        sat_act_label = UILabel()
//        sat_act_label.font = UIFont.boldSystemFont(ofSize: 15)
//        sat_act_label.text = "SAT/ACT"
//        self.addSubview(sat_act_label)
//        sat_act_label.snp.makeConstraints{
//            $0.top.equalTo(application_fee_label.snp.bottom).offset(20)
//            $0.left.equalTo(univRankLabel)
//        }
//
//        sat_act = UILabel()
//        sat_act.text = "Required"
//        sat_act.textColor = UIColor.lightGray
//        sat_act.font = UIFont.boldSystemFont(ofSize: 15)
//        sat_act.numberOfLines = 0
//        self.addSubview(sat_act)
//        sat_act.snp.makeConstraints{
//            $0.top.equalTo(sat_act_label)
//            $0.left.equalTo(sat_act_label.snp.right).offset(10)
//            $0.width.equalTo(self.frame.width-100)
//        }
//
//        high_school_gpa_label = UILabel()
//        high_school_gpa_label.font = UIFont.boldSystemFont(ofSize: 15)
//        high_school_gpa_label.text = "High School GPA"
//        self.addSubview(high_school_gpa_label)
//        high_school_gpa_label.snp.makeConstraints{
//            $0.top.equalTo(sat_act_label.snp.bottom).offset(20)
//            $0.left.equalTo(univRankLabel)
//        }
//
//        high_school_gpa = UILabel()
//        high_school_gpa.text = "Required"
//        high_school_gpa.textColor = UIColor.lightGray
//        high_school_gpa.font = UIFont.boldSystemFont(ofSize: 15)
//        self.addSubview(high_school_gpa)
//        high_school_gpa.snp.makeConstraints{
//            $0.top.equalTo(high_school_gpa_label)
//            $0.left.equalTo(high_school_gpa_label.snp.right).offset(10)
//        }
//
//        acceptance_rate_label = UILabel()
//        acceptance_rate_label.font = UIFont.boldSystemFont(ofSize: 15)
//        acceptance_rate_label.text = "Accepted Rate"
//        self.addSubview(acceptance_rate_label)
//        acceptance_rate_label.snp.makeConstraints{
//            $0.top.equalTo(high_school_gpa_label.snp.bottom).offset(20)
//            $0.left.equalTo(univRankLabel)
//        }
//
//        acceptance_rate = UILabel()
//        acceptance_rate.text = "%60"
//        acceptance_rate.textColor = UIColor.lightGray
//        acceptance_rate.font = UIFont.boldSystemFont(ofSize: 15)
//        self.addSubview(acceptance_rate)
//        acceptance_rate.snp.makeConstraints{
//            $0.top.equalTo(acceptance_rate_label)
//            $0.left.equalTo(acceptance_rate_label.snp.right).offset(10)
//        }
        
    }
}
