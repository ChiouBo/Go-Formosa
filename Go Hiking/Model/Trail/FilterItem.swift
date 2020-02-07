//
//  FilterItem.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/4.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol FilterItem {
    
    var filterButton: String { get }
}

struct FilterGroup {
    
    let items: [FilterItem]
    
}

enum PositionItem: FilterItem {
    
    case allPosition
    
    case east
    
    case west
    
    case north
    
    case south

    var filterButton: String {
        
        switch self {
            
        case .allPosition: return NSLocalizedString("全部區域")
            
        case .east: return NSLocalizedString("東部")
            
        case .west: return NSLocalizedString("西部")
            
        case .north: return NSLocalizedString("北部")
            
        case .south: return NSLocalizedString("南部")
        }
    }
}

enum LevelItem: FilterItem {
    
    case allLevel
    
    case easy
    
    case medium
    
    case hard
    
    var filterButton: String {
        
        switch self {
            
        case .allLevel: return NSLocalizedString("全部類型")
            
        case .easy: return NSLocalizedString("郊  山")
            
        case .medium: return NSLocalizedString("中級山")
            
        case .hard: return NSLocalizedString("百  岳")
            
        }
    }
}
