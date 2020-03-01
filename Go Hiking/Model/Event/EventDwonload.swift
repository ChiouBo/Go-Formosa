//
//  EventDwonload.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/10.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct EventCurrent: Codable {
    
    let image: String
    
    let title: String
    
    let desc: String
    
    let start: String
    
    let end: String
    
    let member: String
    
    let eventID: String
    
    let creater: String
    
    var waitingList: [DocumentReference]
    
    var memberList: [DocumentReference]
    
    var waitingListUser: [UserInfo] = []
    
    var memberListUser: [UserInfo] = []
    
    let requestList: [String]
    
    let chatroomID: String
    
    enum CodingKeys: String, CodingKey {
        
        case image, title, desc, start, end, member, eventID, creater, requestList, waitingList, memberList, chatroomID
    }
    
    var toDict: [String: Any] {
        
        return [
            "Image": image,
            
            "Title": title,
            
            "Desc": desc,

            "Start": start,

            "End": end,

            "Member": member,
            
            "EventID": eventID,
            
            "Creater": creater,
            
            "waitingList": waitingList,
            
            "memberList": memberList,
            
            "requestList": requestList,
            
            "chatroomID": chatroomID
        ]
    }
}
