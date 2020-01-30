//
//  GHTabBarViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/29.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

private enum Tab {
    
    case earth
    
    case trail
    
    case campaign
    
    case chat
    
    case profile
    
    func controller() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .earth: controller = UIStoryboard.earth.instantiateInitialViewController()!
            
        case .trail: controller = UIStoryboard.trail.instantiateInitialViewController()!
            
        case .campaign: controller = UIStoryboard.campaign.instantiateInitialViewController()!
            
        case .chat: controller = UIStoryboard.chat.instantiateInitialViewController()!
            
        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 8.0, left: 0.0, bottom: -8.0, right: 0.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .earth:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Map_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Map_Selected)
            )
            
        case .trail:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Trail_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Trail_Selected)
            )
            
        case .campaign:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_48px_Go_Normal),
                selectedImage: UIImage.asset(.Icons_48px_Go_Selected)
            )
            
        case .chat:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Chat_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Chat_Selected)
            )
            
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_36px_Profile_Normal),
                selectedImage: UIImage.asset(.Icons_36px_Profile_Selected)
            )
        }
    }
}

class GHTabBarViewController: UITabBarController {

    private let tabs: [Tab] = [.earth, .trail, .campaign, .chat, .profile]
    
    var chatTabBarItem: UITabBarItem!
    
    var partnerObserver: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })
        
        // ChatTabBarItem 顯示未讀訊息對象個數
    }

}

extension GHTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        guard let navVC = viewController as? UINavigationController,
            navVC.viewControllers.first is ProfileViewController else { return true }
        
        
        
        
        return true
    }
}
