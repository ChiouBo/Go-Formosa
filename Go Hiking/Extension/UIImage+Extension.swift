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
    case Icons_36px_Campaign_Normal
    case Icons_36px_Campaign_Selected
    case Icons_36px_Chat_Normal
    case Icons_36px_Chat_Selected
    case Icons_36px_Map_Normal
    case Icons_24px_Map_Normal
    case Icons_32px_Map_Normal
    case Icons_36px_Map_Selected
    case Icons_36px_Private_Normal
    case Icons_36px_Private_Selected
    case Icons_36px_Profile_Normal
    case Icons_36px_Profile_Selected
    case Icons_36px_Trail_Normal
    case Icons_36px_Trail_Selected
    case Icons_48px_Go_Normal
    case Icons_48px_Go_Selected
    
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
    
    // Achieve
    case Icon_Goal_Color_1
    case Icon_Goal_Color_2
    case Icon_Goal_Color_3
    case Icon_Goal_Color_4
    case Icon_Goal_Color_5
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
