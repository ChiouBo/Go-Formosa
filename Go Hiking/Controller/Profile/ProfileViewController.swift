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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logout.layer.cornerRadius = 24
    }
    
}
