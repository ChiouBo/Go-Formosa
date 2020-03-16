//
//  FilterItemManager.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/4.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

class FilterItemManager {
    
    let positionGroup = FilterGroup(
    
        items: [
            PositionItem.allPosition,
            PositionItem.east,
            PositionItem.west,
            PositionItem.north,
            PositionItem.south
        ]
    )
    
    let levelGroup = FilterGroup(
    
        items: [
            LevelItem.allLevel,
            LevelItem.easy,
            LevelItem.medium,
            LevelItem.hard
        ]
    )
    
    lazy var groups: [FilterGroup] = [positionGroup, levelGroup]
}
