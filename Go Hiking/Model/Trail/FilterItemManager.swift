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
            SelectedItem.allPosition,
            SelectedItem.east,
            SelectedItem.west,
            SelectedItem.north,
            SelectedItem.south
        ]
    )
    
    lazy var groups: FilterGroup = positionGroup
}
