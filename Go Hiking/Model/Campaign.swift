//
//  Campaign.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/2.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

struct Campaign {
    
    let type: String
    let title: String
    
    static func getAllCampaigns() -> [Campaign] {
        
        return [
            Campaign(type: "Running", title: "象山"),
            Campaign(type: "Running", title: "觀音山"),
            Campaign(type: "Running", title: "金面山"),
            Campaign(type: "Running", title: "劍潭山"),
            Campaign(type: "Running", title: "枕頭山"),
            
            Campaign(type: "Cycling", title: "風櫃嘴"),
            Campaign(type: "Cycling", title: "環島"),
            Campaign(type: "Cycling", title: "巴拉卡公路"),
            
            Campaign(type: "Hiking", title: "雪山"),
            Campaign(type: "Hiking", title: "南湖大山"),
            Campaign(type: "Hiking", title: "大霸尖山"),
            Campaign(type: "Hiking", title: "武陵四秀"),
            
        ]
    }
}
