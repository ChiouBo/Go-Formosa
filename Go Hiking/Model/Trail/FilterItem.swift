//
//  FilterItem.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/4.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol FilterItem {
    
    var title: String { get }
}

struct FilterGroup {
    
    let items: [FilterItem]
}

enum SelectedItem: FilterItem {
    
    case allPosition
    
    case east
    
    case west
    
    case north
    
    case south
    
    var title: String {
        
        switch self {
            
        case .allPosition: return NSLocalizedString("全部")
            
        case .east: return NSLocalizedString("東部")
            
        case .west: return NSLocalizedString("西部")
            
        case .north: return NSLocalizedString("北部")
            
        case .south: return NSLocalizedString("南部")
        }
    }
}
