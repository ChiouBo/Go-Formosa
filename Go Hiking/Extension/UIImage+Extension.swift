//
//  UIImage+Extension.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    
    // TabBar
    case Icons_32px_Campaign_Normal
    case Icons_32px_Campaign_Selected
    case Icons_36px_Chat_Normal
    case Icons_36px_Chat_Selected
    case Icons_32px_Map_Normal
    case Icons_32px_Map_Selected
    case Icons_32px_Private_Normal
    case Icons_32px_Private_Selected
    case Icons_36px_Profile_Normal
    case Icons_36px_Profile_Selected
    case Icons_32px_Trail_Normal
    case Icons_32px_Trail_Selected
    case Icons_32px_Go_Normal
    case Icons_32px_Go_Selected
    
    // Chisel
    case Icons_24px_chisel
    
    // Circle Clean
    case Icons_24px_CleanAll
    
    // Close
    case Icons_24px_Close
    
    // Explore
    case Icons_24px_Explore
    
    // Setting
    case Icons_24px_Settings
    
    // Circle Back
    case Icons_44px_Back01
    
    // Level
    case Icon_Goal_Normal_1
    case Icon_Goal_Normal_2
    case Icon_Goal_Normal_3
    case Icon_Goal_Normal_4
    case Icon_Goal_Normal_5
    case Icon_Goal_Normal_6
    case Icon_Goal_Normal_7
    
    // Achieve
    case Icon_Goal_Color_1
    case Icon_Goal_Color_2
    case Icon_Goal_Color_3
    case Icon_Goal_Color_4
    case Icon_Goal_Color_5
    case Icon_Goal_Color_6
    case Icon_Goal_Color_7
    
    // Gray
    case Icon_Goal_Gray_1
    case Icon_Goal_Gray_2
    case Icon_Goal_Gray_3
    case Icon_Goal_Gray_4
    case Icon_Goal_Gray_5
    case Icon_Goal_Gray_6
    case Icon_Goal_Gray_7
    
    case Icon_Goal_Color_Easy
    case Icon_Goal_Color_Medium
    case Icon_Goal_Color_Hard
    case Icon_Goal_Normal_Easy
    case Icon_Goal_Normal_Medium
    case Icon_Goal_Normal_Hard
    case Icon_Goal_Gray_Easy
    case Icon_Goal_Gray_Medium
    case Icon_Goal_Gray_Hard
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
