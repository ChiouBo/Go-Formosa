//
//  ProfileManager.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation

class ProfileManager {
    
    let achieveGroup = ProfileGroup(
        
        items: [
            AchievementItem.longestDistance,
            AchievementItem.longestTime,
            AchievementItem.mostExplore
        ]
    )
    
    let mountainGroup = ProfileGroup(
        
        items: [
            AchievementItem.typeEasy,
            AchievementItem.typeMedium,
            AchievementItem.typeHard
        ]
    )
    
    let leaderGroup = ProfileGroup(
    
        items: [
            AchievementItem.leading
        ]
    )
    
    
    let userLevelGroup = ProfileGroup(
        
        items: [
            UserLevelItem.rookie,
            UserLevelItem.beginner,
            UserLevelItem.beginnerIntermidiate,
            UserLevelItem.intermediate,
            UserLevelItem.intermediateAdvanced,
            UserLevelItem.advanced,
            UserLevelItem.professional
        ]
    )
    
    lazy var profileGroup: [ProfileGroup] = [achieveGroup, mountainGroup, leaderGroup]
    
    lazy var levelGroup: [ProfileGroup] = [userLevelGroup]
}
