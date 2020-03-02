//
//  GHTabBarViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/29.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Alamofire
import JGProgressHUD
import FirebaseAuth

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
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .earth:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_32px_Map_Normal),
                selectedImage: UIImage.asset(.Icons_32px_Map_Selected)
            )
            
        case .trail:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_32px_Trail_Normal),
                selectedImage: UIImage.asset(.Icons_32px_Trail_Selected)
            )
            
        case .campaign:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icons_32px_Campaign_Normal),
                selectedImage: UIImage.asset(.Icons_32px_Campaign_Selected)
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

class GHTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.earth, .trail, .campaign, .chat, .profile]
    
    var chatTabBarItem: UITabBarItem!
    
    var partnerObserver: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.LightGrayBlue
        
        viewControllers = tabs.map({ $0.controller() })
        
        delegate = self
        // ChatTabBarItem 顯示未讀訊息對象個數
    }

    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        guard let navVC = viewController as? UINavigationController,
            navVC.viewControllers.first is ProfileViewController || navVC.viewControllers.first is ChatViewController else {
                return true
        }
        guard Auth.auth().currentUser != nil else {
        
                    if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
        
                        authVC.modalPresentationStyle = .overCurrentContext
        
                        present(authVC, animated: false, completion: nil)
                    }
        
                    return false
                }

        return true
    }
}
