//
//  ProfileViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logout: UIButton!
    
    @IBAction func logout(_ sender: UIButton) {
        
        let manager = LoginManager()
        
        manager.logOut()
        
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logout.layer.cornerRadius = 24
    }
    
}
