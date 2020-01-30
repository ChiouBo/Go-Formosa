//
//  AuthViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

class AuthViewController: UIViewController {

    @IBOutlet weak var ghSignUp: UIButton!
    
    @IBOutlet weak var ghFacebookLogin: UIButton!
    
    @IBOutlet weak var ghAppleLogin: UIButton!
    
    @IBOutlet weak var ghLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ghSignUp.layer.cornerRadius = 24
        ghFacebookLogin.layer.cornerRadius = 24
        ghAppleLogin.layer.cornerRadius = 24
        ghLogin.layer.cornerRadius = 24
    }
    
    @IBAction func ghSignUp(_ sender: UIButton) {
    }
    
    @IBAction func ghFacebookLogin(_ sender: UIButton) {
        
        let manager = LoginManager()
        
        manager.logIn(permissions: [.publicProfile], viewController: self) { (result) in
            
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                
                print("Login Success")
                
            } else {
                
                print("Login Fail")
            }
        }
    }
    
    @IBAction func ghAppleLogin(_ sender: UIButton) {
    }
    
    @IBAction func ghLogin(_ sender: UIButton) {
    }
    
    
}
