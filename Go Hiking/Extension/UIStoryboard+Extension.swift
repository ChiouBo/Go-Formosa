//
//  UIStoryboard+Extension.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let earth = "Map"
    
    static let trail = "Trail"
    
    static let campaign = "Campaign"
    
    static let chat = "Chat"
    
    static let profile = "Profile"
    
    static let auth = "Auth"
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return ghStoryboard(name: StoryboardCategory.main) }
    
    static var earth: UIStoryboard { return ghStoryboard(name: StoryboardCategory.earth) }
    
    static var trail: UIStoryboard { return ghStoryboard(name: StoryboardCategory.trail) }
    
    static var campaign: UIStoryboard { return ghStoryboard(name: StoryboardCategory.campaign) }
    
    static var chat: UIStoryboard { return ghStoryboard(name: StoryboardCategory.chat) }
    
    static var profile: UIStoryboard { return ghStoryboard(name: StoryboardCategory.profile) }
    
    static var auth: UIStoryboard { return ghStoryboard(name: StoryboardCategory.auth) }
    
    private static func ghStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
