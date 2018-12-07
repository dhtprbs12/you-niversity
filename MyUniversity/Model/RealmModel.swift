//
//  RealmModel.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 31..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import RealmSwift

//UserInfo
class UserInfo: Object{
    
    // 0:false,1:true
    @objc dynamic var user_id = 0
    @objc dynamic var nickname = ""
    @objc dynamic var password = ""
    @objc dynamic var token = ""
    @objc dynamic var push  = 1
    @objc dynamic var coin = 0
    
    
    //Set primary key
    override static func primaryKey() -> String? {
        return "user_id"
    }
}

//Mentor Info
class MentorInfo:Object{
    @objc dynamic var mentor_id = 0
    @objc dynamic var user_id = 0
    @objc dynamic var mentor_nickname = ""
    @objc dynamic var mentor_university = ""
    @objc dynamic var mentor_major = ""
    @objc dynamic var mentor_background_url = ""
    @objc dynamic var mentor_profile_url = ""
    @objc dynamic var mentor_mentoring_area = ""
    @objc dynamic var mentor_mentoring_field = ""
    @objc dynamic var mentor_introduction = ""
    @objc dynamic var mentor_information = ""
    
    //Set primary key
    override static func primaryKey() -> String? {
        return "mentor_id"
    }
}

//objects for conversation
//class Message:Object{
//    @objc dynamic var message_id = 0
//    @objc dynamic var conversation_id = 0
//    @objc dynamic var sender_id = 0
//    @objc dynamic var receiver_id = 0
//    @objc dynamic var sender_name = ""
//    @objc dynamic var message_type = ""
//    @objc dynamic var message = ""
//    @objc dynamic var created_at : Date? = nil
//    @objc dynamic var is_read = ""
//
//
//    override static func primaryKey()->String?{
//        return "message_id"
//    }
//}

//class Message:Object{
//    @objc dynamic var message_id = 0
//    @objc dynamic var conversation_id = 0
//    @objc dynamic var sender_id = 0
//    @objc dynamic var receiver_id = 0
//    @objc dynamic var sender_name = ""
//    @objc dynamic var message_type = ""
//    @objc dynamic var message = ""
//    @objc dynamic var created_at : Date? = nil
//    @objc dynamic var is_read = ""
//}

//class Conversation:Object{
//    @objc dynamic var coversation_id = 0
//    let message_list = List<Message>()
//
//    override static func primaryKey()->String?{
//        return "coversation_id"
//    }
//
//}


class Attendance: Object{
    @objc dynamic var user_id = 0
    @objc dynamic var attendance_time = ""
    
    override static func primaryKey() -> String? {
        return "user_id"
    }
}

//class Conversation:Object{
//    @objc dynamic var converation_id = 0
//    let messageList = List<Message>()
//
//    override static func primaryKey()->String?{
//        return "conversation_id"
//    }
//}
//
//class ConversationList:Object{
//    let conversationList = List<Conversation>()
//}

