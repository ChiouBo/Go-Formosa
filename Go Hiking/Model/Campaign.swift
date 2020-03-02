//
//  Campaign.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/2.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit

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


struct Record {
    
    let time: String
    let title: String
    
    static func getAllRecords() -> [Record] {
        
        return [
            
            Record(time: "2020.03.09", title: "台北大縱走"),
            Record(time: "2020.02.25", title: "黃金十稜"),
            Record(time: "2020.02.18", title: "巴拉卡公路"),
            Record(time: "2020.02.11", title: "鳶嘴捎來縱走"),
            Record(time: "2020.02.10", title: "風櫃嘴"),
            Record(time: "2020.02.03", title: "枕頭山"),
            Record(time: "2020.02.01", title: "越野跑劍潭山"),
            Record(time: "2020.01.17", title: "金面山"),
            Record(time: "2020.01.15", title: "越野跑軍艦岩"),
            Record(time: "2020.01.01", title: "雪山"),
        ]
    }
}

struct Polyline {
    
    let image: UIImage
    
    static func getAllLines() -> [Polyline] {
        
        return [
        
            Polyline(image: UIImage(named: "001") ?? UIImage()),
            Polyline(image: UIImage(named: "002") ?? UIImage()),
            Polyline(image: UIImage(named: "003") ?? UIImage()),
            Polyline(image: UIImage(named: "004") ?? UIImage()),
            Polyline(image: UIImage(named: "005") ?? UIImage()),
            Polyline(image: UIImage(named: "006") ?? UIImage()),
            Polyline(image: UIImage(named: "007") ?? UIImage()),
            Polyline(image: UIImage(named: "008") ?? UIImage()),
            Polyline(image: UIImage(named: "001") ?? UIImage()),
           
        ]
    }
}
