//
//  EventObject.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit

struct EventContent {
    
    var image: [UIImage] = []
    
    var title: String
    
    var desc: String
    
    var start: String
    
    var end: String
    
    var amount: String
    
    var location: String
    
    var toDict: [String: Any] {
        
        return [
            "Image": image,
            
            "Title": title,
            
            "Desc": desc,

            "Start": start,

            "End": end,

            "Amount": amount,
            
            "Location": location
        ]
    }
    
}
