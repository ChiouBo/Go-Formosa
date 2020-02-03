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
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
