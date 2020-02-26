//
//  ProfileItem.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol ProfileItem {
    
    var image: UIImage? { get }
    
    var title: String { get }
    
    var desc: String { get }
}

struct ProfileGroup {
    
    let items: [ProfileItem]
}

enum achieveItem: ProfileItem {
    
    case longestDistance
    
    case longestTime
    
    case mostExplore
    
    var image: UIImage? {
        
        switch self {
            
        case .longestDistance: return UIImage.asset(.Icon_Goal_Gray_1)
            
        case .longestTime: return UIImage.asset(.Icon_Goal_Gray_2)
            
        case .mostExplore: return UIImage.asset(.Icon_Goal_Gray_3)
            
        }
    }
    
    var title: String {
        
        switch self {
            
        case .longestDistance: return NSLocalizedString("最長距離紀錄")
            
        case .longestTime: return NSLocalizedString("最長時間紀錄")
            
        case .mostExplore: return NSLocalizedString("最高探索紀錄")
            
        }
        
    }
    var desc: String {
        
        switch self {
            
        case .longestDistance: return NSLocalizedString("0.0公里")
            
        case .longestTime: return NSLocalizedString("0.0 小時")
            
        case .mostExplore: return NSLocalizedString("0.0 公尺")
        }
    }
    
}

enum mountainItem: ProfileItem {
    
    case typeEasy
    
    case typeMedium
    
    case typeHard
    
    var image: UIImage? {
        
        switch self {
            
        case .typeEasy: return UIImage.asset(.Icon_Goal_Gray_Easy)
            
        case .typeMedium: return UIImage.asset(.Icon_Goal_Gray_Medium)
            
        case .typeHard: return UIImage.asset(.Icon_Goal_Gray_Hard)
            
        }
    }
    
    var title: String {
        
        switch self {
            
        case .typeEasy: return NSLocalizedString("郊山")
            
        case .typeMedium: return NSLocalizedString("中級山")
            
        case .typeHard: return NSLocalizedString("百岳")
            
        }
        
    }
    var desc: String {
        
        switch self {
            
        case .typeEasy: return NSLocalizedString("5座")
            
        case .typeMedium: return NSLocalizedString("3座")
            
        case .typeHard: return NSLocalizedString("2座")
        }
    }
}

enum LeaderItem: ProfileItem {
    
    case leading
    
    var image: UIImage? {
        
        switch self {
            
        case .leading: return UIImage.asset(.Icon_Goal_Gray_7)
        }
    }
    
    var title: String {
        
        switch self {
            
        case .leading: return NSLocalizedString("領隊")
        }
    }
    
    var desc: String {
        
        switch self {
            
        case .leading: return NSLocalizedString("0次")
        }
    }
}

enum UserLevelItem: ProfileItem {
    
    case rookie
    
    case beginner
    
    case beginnerIntermidiate
    
    case intermediate
    
    case intermediateAdvanced
    
    case advanced
    
    case professional
    
    var image: UIImage? {
        
        switch self {
            
        case .rookie: return UIImage.asset(.Icon_Goal_Gray_1)
            
        case .beginner: return UIImage.asset(.Icon_Goal_Gray_2)
            
        case .beginnerIntermidiate: return UIImage.asset(.Icon_Goal_Gray_3)
            
        case .intermediate: return UIImage.asset(.Icon_Goal_Gray_4)
            
        case .intermediateAdvanced: return UIImage.asset(.Icon_Goal_Gray_5)
            
        case .advanced: return UIImage.asset(.Icon_Goal_Gray_6)
            
        case .professional: return UIImage.asset(.Icon_Goal_Gray_7)
        }
    }
    
    var title: String {
        
        switch self {
            
        case .rookie: return NSLocalizedString("菜鳥山友")
            
        case .beginner: return NSLocalizedString("新手山友")
            
        case .beginnerIntermidiate: return NSLocalizedString("健腳山友")
            
        case .intermediate: return NSLocalizedString("癡迷山友")
            
        case .intermediateAdvanced: return NSLocalizedString("探索老手")
            
        case .advanced: return NSLocalizedString("探索高手")
            
        case .professional: return NSLocalizedString("專家")
        }
    }
    
    var desc: String {
        
        switch self {
            
        case .rookie: return NSLocalizedString("達成 5 次探索")
            
        case .beginner: return NSLocalizedString("達成 10 次探索")
            
        case .beginnerIntermidiate: return NSLocalizedString("達成 20 次探索")
            
        case .intermediate: return NSLocalizedString("達成 40 次探索")
            
        case .intermediateAdvanced: return NSLocalizedString("達成 60 次探索")
            
        case .advanced: return NSLocalizedString("達成 80 次探索")
            
        case .professional: return NSLocalizedString("達成 100 次探索")
        }
    }
}
