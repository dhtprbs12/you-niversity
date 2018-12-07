//
//  CustomizedObject.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 6. 18..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import Kingfisher

class BoardObject:NSObject, NSCoding{
    var board_id : Int = 0
    var user_id : Int = 0
    var board_type: String = ""
    var board_university: String = ""
    var board_major: String = ""
    var board_title : String = ""
    var board_content: String = ""
    var touch_count: Int = 0
    var comment_count: Int = 0
    var board_created : String = ""
    var user_nickname : String = ""
    
    init(board_id:Int,user_id:Int,board_type:String,board_university:String,board_major:String,board_title : String,board_content: String,touch_count: Int,comment_count: Int,board_created : String,user_nickname : String){
        self.board_id = board_id
        self.user_id = user_id
        self.board_type = board_type
        self.board_university = board_university
        self.board_major = board_major
        self.board_title = board_title
        self.board_content = board_content
        self.touch_count = touch_count
        self.comment_count = comment_count
        self.board_created = board_created
        self.user_nickname = user_nickname
    }
    
    //need to do these below to store customized object into UserDefault
    //object type should by "class" not "struct"
    required convenience init(coder aDecoder: NSCoder) {
        let board_id = aDecoder.decodeInteger(forKey: "board_id")
        let user_id = aDecoder.decodeInteger(forKey: "user_id")
        let board_type = aDecoder.decodeObject(forKey: "board_type") as! String
        let board_university = aDecoder.decodeObject(forKey: "board_university") as! String
        let board_major = aDecoder.decodeObject(forKey: "board_major") as! String
        let board_title = aDecoder.decodeObject(forKey: "board_title") as! String
        let board_content = aDecoder.decodeObject(forKey: "board_content") as! String
        let touch_count = aDecoder.decodeInteger(forKey: "touch_count")
        let comment_count = aDecoder.decodeInteger(forKey: "comment_count")
        let board_created = aDecoder.decodeObject(forKey: "board_created") as! String
        let user_nickname = aDecoder.decodeObject(forKey: "user_nickname") as! String
        self.init(board_id: board_id, user_id: user_id, board_type: board_type,board_university:board_university,board_major:board_major,board_title:board_title,board_content:board_content,touch_count:touch_count,comment_count:comment_count,board_created:board_created,user_nickname:user_nickname)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(board_id, forKey: "board_id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(board_type, forKey: "board_type")
        aCoder.encode(board_university, forKey: "board_university")
        aCoder.encode(board_major, forKey: "board_major")
        aCoder.encode(board_title, forKey: "board_title")
        aCoder.encode(board_content, forKey: "board_content")
        aCoder.encode(touch_count, forKey: "touch_count")
        aCoder.encode(comment_count, forKey: "comment_count")
        aCoder.encode(board_created, forKey: "board_created")
        aCoder.encode(user_nickname, forKey: "user_nickname")
    }
}

class MentorObject:NSObject, NSCoding{
    var number_id : Int = 0
    var mentor_id : Int = 0
    var user_id : Int = 0
    var mentor_nickname : String = ""
    var mentor_university : String = ""
    var mentor_major : String = ""
    var mentor_backgroundurl : String = ""
    var mentor_profileurl : String = ""
    var mentor_mentoring_area : String = ""
    var mentor_mentoring_field : String = ""
    var mentor_introduction : String = ""
    var mentor_information : String = ""
    var mentor_touch_count : Int = 0
    var mentor_favorite_count : Int = 0
    var mentor_is_active : Int = 0
    var mentor_created_at : String = ""
    
    init(number_id:Int,mentor_id:Int,user_id:Int,mentor_nickname:String,mentor_university:String,mentor_major:String,mentor_backgroundurl:String,mentor_profileurl:String,mentor_mentoring_area:String,mentor_mentoring_field:String,mentor_introduction:String,mentor_information:String,mentor_touch_count:Int,mentor_favorite_count:Int,mentor_is_active:Int,mentor_created_at:String){
        self.number_id = number_id
        self.mentor_id = mentor_id
        self.user_id = user_id
        self.mentor_nickname = mentor_nickname
        self.mentor_university = mentor_university
        self.mentor_major = mentor_major
        self.mentor_backgroundurl = mentor_backgroundurl
        self.mentor_profileurl = mentor_profileurl
        self.mentor_mentoring_area = mentor_mentoring_area
        self.mentor_mentoring_field = mentor_mentoring_field
        self.mentor_introduction = mentor_introduction
        self.mentor_information = mentor_information
        self.mentor_touch_count = mentor_touch_count
        self.mentor_favorite_count = mentor_favorite_count
        self.mentor_is_active = mentor_is_active
        self.mentor_created_at = mentor_created_at
    }
    //need to do these below to store customized object into UserDefault
    //object type should by "class" not "struct"
    required convenience init(coder aDecoder: NSCoder){
        let number_id = aDecoder.decodeInteger(forKey: "number_id")
        let mentor_id = aDecoder.decodeInteger(forKey: "mentor_id")
        let user_id = aDecoder.decodeInteger(forKey: "user_id")
        let mentor_nickname = aDecoder.decodeObject(forKey: "mentor_nickname") as! String
        let mentor_university = aDecoder.decodeObject(forKey: "mentor_university") as! String
        let mentor_major = aDecoder.decodeObject(forKey: "mentor_major") as! String
        let mentor_backgroundurl = aDecoder.decodeObject(forKey: "mentor_backgroundurl") as! String
        let mentor_profileurl = aDecoder.decodeObject(forKey: "mentor_profileurl") as! String
        let mentor_mentoring_area = aDecoder.decodeObject(forKey: "mentor_mentoring_area") as! String
        let mentor_mentoring_field = aDecoder.decodeObject(forKey: "mentor_mentoring_field") as! String
        let mentor_introduction = aDecoder.decodeObject(forKey: "mentor_introduction") as! String
        let mentor_information = aDecoder.decodeObject(forKey: "mentor_information") as! String
        let mentor_touch_count = aDecoder.decodeInteger(forKey: "mentor_touch_count")
        let mentor_favorite_count = aDecoder.decodeInteger(forKey: "mentor_favorite_count")
        let mentor_is_active = aDecoder.decodeInteger(forKey: "mentor_is_active")
        let mentor_created_at = aDecoder.decodeObject(forKey: "mentor_created_at") as! String
        
        self.init(number_id:number_id,mentor_id:mentor_id,user_id:user_id,mentor_nickname:mentor_nickname,mentor_university:mentor_university,mentor_major:mentor_major,mentor_backgroundurl:mentor_backgroundurl,mentor_profileurl:mentor_profileurl,mentor_mentoring_area:mentor_mentoring_area,mentor_mentoring_field:mentor_mentoring_field,mentor_introduction:mentor_introduction,mentor_information:mentor_information,mentor_touch_count:mentor_touch_count,mentor_favorite_count:mentor_favorite_count,mentor_is_active:mentor_is_active,mentor_created_at:mentor_created_at)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(number_id, forKey: "number_id")
        aCoder.encode(mentor_id, forKey: "mentor_id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(mentor_nickname, forKey: "mentor_nickname")
        aCoder.encode(mentor_university, forKey: "mentor_university")
        aCoder.encode(mentor_major, forKey: "mentor_major")
        aCoder.encode(mentor_backgroundurl, forKey: "mentor_backgroundurl")
        aCoder.encode(mentor_profileurl, forKey: "mentor_profileurl")
        aCoder.encode(mentor_mentoring_area, forKey: "mentor_mentoring_area")
        aCoder.encode(mentor_mentoring_field, forKey: "mentor_mentoring_field")
        aCoder.encode(mentor_introduction, forKey: "mentor_introduction")
        aCoder.encode(mentor_information, forKey: "mentor_information")
        aCoder.encode(mentor_touch_count, forKey: "mentor_touch_count")
        aCoder.encode(mentor_favorite_count, forKey: "mentor_favorite_count")
        aCoder.encode(mentor_is_active, forKey: "mentor_is_active")
        aCoder.encode(mentor_created_at, forKey: "mentor_created_at")
    }
}


//univeristy
class UniversityObject:NSObject,NSCoding{
    var university_id : Int = 0
    var name : String = ""
    var ranking : String = ""
    var website : String = ""
    var address : String = ""
    var num_of_students : String = ""
    var tuition_fee : String = ""
    var sat : String = ""
    var act : String = ""
    var application_fee : String = ""
    var sat_act : String = ""
    var high_school_gpa : String = ""
    var acceptance_rate : String = ""
    var crawling_url : String = ""

    
    init(university_id:Int,name:String,ranking:String,website:String,address:String,num_of_students:String,tuition_fee:String,sat:String,act:String,application_fee:String,sat_act:String,high_school_gpa:String,acceptance_rate:String,crawling_url:String){
        self.university_id = university_id
        self.name = name
        self.ranking = ranking
        self.website = website
        self.address = address
        self.num_of_students = num_of_students
        self.tuition_fee = tuition_fee
        self.sat = sat
        self.act = act
        self.application_fee = application_fee
        self.sat_act = sat_act
        self.high_school_gpa = high_school_gpa
        self.acceptance_rate = acceptance_rate
        self.crawling_url = crawling_url
        
    }
    
    //need to do these below to store customized object into UserDefault
    //object type should by "class" not "struct"
    required convenience init(coder aDecoder: NSCoder){
        let university_id = aDecoder.decodeInteger(forKey: "university_id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let ranking = aDecoder.decodeObject(forKey: "ranking") as! String
        let website = aDecoder.decodeObject(forKey: "website") as! String
        let address = aDecoder.decodeObject(forKey: "address") as! String
        let num_of_students = aDecoder.decodeObject(forKey: "num_of_students") as! String
        let tuition_fee = aDecoder.decodeObject(forKey: "tuition_fee") as! String
        let sat = aDecoder.decodeObject(forKey: "sat") as! String
        let act = aDecoder.decodeObject(forKey: "act") as! String
        let application_fee = aDecoder.decodeObject(forKey: "application_fee") as! String
        let sat_act = aDecoder.decodeObject(forKey: "sat_act") as! String
        let high_school_gpa = aDecoder.decodeObject(forKey: "high_school_gpa") as! String
        let acceptance_rate = aDecoder.decodeObject(forKey: "acceptance_rate") as! String
        let crawling_url = aDecoder.decodeObject(forKey: "crawling_url") as! String
        
        
        self.init(university_id:university_id,name:name,ranking:ranking,website:website,address:address,num_of_students:num_of_students,tuition_fee:tuition_fee,sat:sat,act:act,application_fee:application_fee,sat_act:sat_act,high_school_gpa:high_school_gpa,acceptance_rate:acceptance_rate,crawling_url:crawling_url)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(university_id, forKey: "university_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(ranking, forKey: "ranking")
        aCoder.encode(website, forKey: "website")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(num_of_students, forKey: "num_of_students")
        aCoder.encode(tuition_fee, forKey: "tuition_fee")
        aCoder.encode(sat, forKey: "sat")
        aCoder.encode(act, forKey: "act")
        aCoder.encode(application_fee, forKey: "application_fee")
        aCoder.encode(sat_act, forKey: "sat_act")
        aCoder.encode(high_school_gpa, forKey: "high_school_gpa")
        aCoder.encode(acceptance_rate, forKey: "acceptance_rate")
        aCoder.encode(crawling_url, forKey: "crawling_url")
        
    }
}

class CommentObject:NSObject, NSCoding{
    var comment_reply_id : Int = 0
    var comment_id : Int = 0
    var board_id : Int = 0
    var user_id : Int = 0
    var receiver_id : Int = 0
    var user_nickname : String = ""
    var comment_content : String = ""
    var comment_created : String = ""
    init(comment_reply_id:Int,comment_id:Int,board_id:Int,user_id:Int,receiver_id:Int,user_nickname:String,comment_content:String,comment_created:String){
        self.comment_reply_id = comment_reply_id
        self.comment_id = comment_id
        self.board_id = board_id
        self.user_id = user_id
        self.receiver_id = receiver_id
        self.user_nickname = user_nickname
        self.comment_content = comment_content
        self.comment_created = comment_created
        
    }
    //need to do these below to store customized object into UserDefault
    //object type should by "class" not "struct"
    required convenience init(coder aDecoder: NSCoder){
        let comment_reply_id = aDecoder.decodeInteger(forKey: "comment_reply_id")
        let comment_id = aDecoder.decodeInteger(forKey: "comment_id")
        let board_id = aDecoder.decodeInteger(forKey: "board_id")
        let user_id = aDecoder.decodeInteger(forKey: "user_id")
        let receiver_id = aDecoder.decodeInteger(forKey: "receiver_id")
        let user_nickname = aDecoder.decodeObject(forKey: "user_nickname") as! String
        let comment_content = aDecoder.decodeObject(forKey: "comment_content") as! String
        let comment_created = aDecoder.decodeObject(forKey: "comment_created") as! String
        
        self.init(comment_reply_id:comment_reply_id,comment_id:comment_id,board_id:board_id,user_id:user_id,receiver_id:receiver_id,user_nickname:user_nickname,comment_content:comment_content,comment_created:comment_created)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(comment_reply_id, forKey: "comment_reply_id")
        aCoder.encode(comment_id, forKey: "comment_id")
        aCoder.encode(board_id, forKey: "board_id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(receiver_id, forKey: "receiver_id")
        aCoder.encode(user_nickname, forKey: "user_nickname")
        aCoder.encode(comment_content, forKey: "comment_content")
        aCoder.encode(comment_created, forKey: "comment_created")
    }
}

class MentorCommentObject:NSObject, NSCoding{
    var replied_comment_id : Int = 0
    var comment_id : Int = 0
    var mentor_id : Int = 0
    var user_id : Int = 0
    var receiver_id : Int = 0
    var user_nickname : String = ""
    var profileurl : String = ""
    var content : String = ""
    var comment_created : String = ""
    init(replied_comment_id:Int,comment_id:Int,mentor_id:Int,user_id:Int,receiver_id:Int,user_nickname:String,profileurl:String,content:String,comment_created:String){
        self.replied_comment_id = replied_comment_id
        self.comment_id = comment_id
        self.mentor_id = mentor_id
        self.user_id = user_id
        self.receiver_id = receiver_id
        self.user_nickname = user_nickname
        self.profileurl = profileurl
        self.content = content
        self.comment_created = comment_created
        
    }
    //need to do these below to store customized object into UserDefault
    //object type should by "class" not "struct"
    required convenience init(coder aDecoder: NSCoder){
        let replied_comment_id = aDecoder.decodeInteger(forKey: "replied_comment_id")
        let comment_id = aDecoder.decodeInteger(forKey: "comment_id")
        let mentor_id = aDecoder.decodeInteger(forKey: "mentor_id")
        let user_id = aDecoder.decodeInteger(forKey: "user_id")
        let receiver_id = aDecoder.decodeInteger(forKey: "receiver_id")
        let user_nickname = aDecoder.decodeObject(forKey: "user_nickname") as! String
        let profileurl = aDecoder.decodeObject(forKey: "profileurl") as! String
        let content = aDecoder.decodeObject(forKey: "content") as! String
        let comment_created = aDecoder.decodeObject(forKey: "comment_created") as! String
        
        self.init(replied_comment_id:replied_comment_id,comment_id:comment_id,mentor_id:mentor_id,user_id:user_id,receiver_id:receiver_id,user_nickname:user_nickname,profileurl:profileurl,content:content,comment_created:comment_created)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(replied_comment_id, forKey: "replied_comment_id")
        aCoder.encode(comment_id, forKey: "comment_id")
        aCoder.encode(mentor_id, forKey: "mentor_id")
        aCoder.encode(user_id, forKey: "user_id")
        aCoder.encode(receiver_id, forKey: "receiver_id")
        aCoder.encode(user_nickname, forKey: "user_nickname")
        aCoder.encode(profileurl, forKey: "profileurl")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(comment_created, forKey: "comment_created")
    }
}

//class SharedCommentObject:NSObject, NSCoding{
//
//    var comment_id : Int = 0
//    var id : Int = 0 //this could be board_id or mentor_id
//    var user_id : Int = 0
//    var receiver_id : Int = 0
//    var user_nickname : String = ""
//    var profileurl : String = ""
//    var content : String = ""
//    var comment_created : String = ""
//    init(comment_id:Int,id:Int,user_id:Int,receiver_id:Int,user_nickname:String,profileurl:String,content:String,comment_created:String){
//        self.comment_id = comment_id
//        self.id = id
//        self.user_id = user_id
//        self.receiver_id = receiver_id
//        self.user_nickname = user_nickname
//        self.profileurl = profileurl
//        self.content = content
//        self.comment_created = comment_created
//
//    }
//    //need to do these below to store customized object into UserDefault
//    //object type should by "class" not "struct"
//    required convenience init(coder aDecoder: NSCoder){
//        let comment_id = aDecoder.decodeInteger(forKey: "comment_id")
//        let id = aDecoder.decodeInteger(forKey: "id")
//        let user_id = aDecoder.decodeInteger(forKey: "user_id")
//        let receiver_id = aDecoder.decodeInteger(forKey: "receiver_id")
//        let user_nickname = aDecoder.decodeObject(forKey: "user_nickname") as! String
//        let profileurl = aDecoder.decodeObject(forKey: "profileurl") as! String
//        let content = aDecoder.decodeObject(forKey: "content") as! String
//        let comment_created = aDecoder.decodeObject(forKey: "comment_created") as! String
//
//        self.init(comment_id:comment_id,id:id,user_id:user_id,receiver_id:receiver_id,user_nickname:user_nickname,profileurl:profileurl,content:content,comment_created:comment_created)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(comment_id, forKey: "comment_id")
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(user_id, forKey: "user_id")
//        aCoder.encode(user_id, forKey: "receiver_id")
//        aCoder.encode(user_nickname, forKey: "user_nickname")
//        aCoder.encode(profileurl, forKey: "profileurl")
//        aCoder.encode(content, forKey: "content")
//        aCoder.encode(comment_created, forKey: "comment_created")
//    }
//}

class CustomizedObject{
    //time difference calculator
    static func calculateElapsedTime(created:String) -> String{
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        //current
        let time : TimeZone = TimeZone.ReferenceType.system // 시스템 시간대
        let nowDate : Date = Date(timeIntervalSinceNow: TimeInterval(time.secondsFromGMT())) // 로컬 시간
        
        //created
        let made = formatter.date(from: created)
        
        //calendar
        let calendar = Calendar.current
        let elapsedyear = calendar.dateComponents([.year], from: made!, to: nowDate)
        let elapsedmonth = calendar.dateComponents([.month], from: made!, to: nowDate)
        let elapsedday = calendar.dateComponents([.day], from: made!, to: nowDate)
        let elapsedhour = calendar.dateComponents([.hour], from: made!, to: nowDate)
        let elapsedminute = calendar.dateComponents([.minute], from: made!, to: nowDate)
        let elapsedsecond = calendar.dateComponents([.second], from: made!, to: nowDate)
        //print("\(made!) - \(nowDate)")
        //print("\(elapsedyear) - \(elapsedmonth) - \(elapsedday) - \(elapsedhour) - \(elapsedminute) - \(elapsedsecond)")
        if(elapsedyear.year! == 0){
            //같은 년도 이면
            if(elapsedmonth.month! == 0){
                //같은 월 이면
                if(elapsedday.day! == 0){
                    //같은 일 이면
                    if(elapsedhour.hour! == 0){
                        //같은 시간 이면
                        if(elapsedminute.minute! == 0){
                            //같은 분 이면
                            if(elapsedsecond.second! == 0){
                                return "Just Now"
                            }else{
                                return "\(elapsedsecond.second!) secs ago"
                            }
                        }else{
                            return "\(elapsedminute.minute!) mins ago"
                        }
                    }else{
                        return "\(elapsedhour.hour!) hours ago"
                    }
                }else{
                    return "\(elapsedday.day!) days ago"
                }
            }else{
                return created
                //return "\(elapsedmonth.month!) 월 전"
            }
        }else{
            return created
            //return "\(elapsedyear.year!) 년 전"
        }
    }
}




