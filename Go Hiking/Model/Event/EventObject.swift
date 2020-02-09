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
    
let image: UIImage
    
let title: String
    
let desc: String
    
let start: String
    
let end: String
    
    var toDict: [String: Any] {
        
        return [
            "Image": image,
            "Title": title,
            "Desc": desc,
            "Start": start,
            "End": end
        ]
    }

}
