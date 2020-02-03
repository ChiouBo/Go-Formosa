//
//  Campaign.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/2.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

struct Campaign {
    
    let level: String
    let title: String
    
    static func getAllCampaigns() -> [Campaign] {
        
        return [
            Campaign(level: "Easy", title: "象山"),
            Campaign(level: "Easy", title: "觀音山"),
            Campaign(level: "Easy", title: "金面山"),
            Campaign(level: "Easy", title: "劍潭山"),
            Campaign(level: "Easy", title: "枕頭山"),
            
            Campaign(level: "Medium", title: "五寮尖山"),
            Campaign(level: "Medium", title: "孝子山"),
            Campaign(level: "Medium", title: "皇帝殿"),
            
            Campaign(level: "Hard", title: "雪山"),
            Campaign(level: "Hard", title: "南湖大山"),
            Campaign(level: "Hard", title: "大霸尖山"),
            Campaign(level: "Hard", title: "武陵四秀"),
            
        ]
    }
}
