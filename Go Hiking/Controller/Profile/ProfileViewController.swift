//
//  ProfileViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    private enum contentType: Int {
        
        case history = 0
        
        case achievement = 1
        
        case level = 2
    }
    
    @IBOutlet weak var userBackground: UIImageView!
    
    @IBOutlet weak var profileContent: UIView!
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    //
    @IBOutlet weak var indicator: UIView!
    
    @IBOutlet weak var indicatorConstaint: NSLayoutConstraint!
    
    @IBOutlet var contentChange: [UIButton]!
    
    @IBAction func toChangeContent(_ sender: UIButton) {
        
        for button in contentChange {
            
            button.isSelected = false
        }
        
        sender.isSelected = true
        
        moveIndicatorView(reference: sender)
        
        guard let type = contentType(rawValue: sender.tag) else { return }
        
        updateContainer(type: type)
    }
    
    var containerViews: [UIView] {
        
        return [userHistory, userAchievement, userLevel]
    }
    
    @IBOutlet weak var userHistory: UIView!
    
    @IBOutlet weak var userAchievement: UIView!
    
    @IBOutlet weak var userLevel: UIView!
    
    @IBOutlet weak var logout: UIButton!
    
    @IBAction func logout(_ sender: UIButton) {
        
        let manager = LoginManager()
        
        manager.logOut()
        
        do{
            try Auth.auth().signOut()
          
        } catch let logOutError {
          
          print(logOutError)
        }
        
        let mainStoryboard = UIStoryboard.main
        
        guard let mainVC = mainStoryboard.instantiateViewController(
            withIdentifier: "mainVC") as? GHTabBarViewController else {
                return
        }
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = mainVC
    }
    
    private func moveIndicatorView(reference: UIView) {
        
        self.view.layoutIfNeeded()
        
        indicatorConstaint.isActive = false

        indicatorConstaint = indicator.centerXAnchor.constraint(equalTo: reference.centerXAnchor)

        indicatorConstaint.isActive = true
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
    
    private func updateContainer(type: contentType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .history:
            indicator.isHidden = false
            
        case .achievement:
            indicator.isHidden = false
            
        case .level:
            indicator.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setProfileUI()
    }
    
    override func viewWillLayoutSubviews() {
        setProfileUI()
    }
    
    func setProfileUI() {
        //        logout.layer.cornerRadius = 24

        profileContent.layer.cornerRadius = 500
        
        userPhoto.layer.cornerRadius = 50
        userPhoto.layer.borderWidth = 3
        userPhoto.layer.borderColor = UIColor.white.cgColor
       }
    
}
