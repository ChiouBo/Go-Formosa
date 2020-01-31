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
import Firebase
import JGProgressHUD

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
        
        if let token = AccessToken.current {
            
            print("\(token.userID) login")
        } else {
            
            print("no login")
        }
        
    }
    
    @IBAction func ghSignUp(_ sender: UIButton) {
    }
    
    @IBAction func ghFacebookLogin(_ sender: UIButton) {
        
        let manager = LoginManager()
        
        manager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            
            if case LoginResult.success(granted: _, declined: _, token: _) = result {
                
                print("Login Success")
                
                LKProgressHUD.showSuccess(text: "登入成功！")
                
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "登入成功"
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 1.0)
                
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
                
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    
                    if let error = error {
                        
                        print("Login error: \(error.localizedDescription)")
                        
                        LKProgressHUD.showFailure(text: "Facebook 登入錯誤！")
                    }
                    
                    print("\(credential)")
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.presentingViewController?.dismiss(animated: false, completion: nil)
                }
                
            } else {
                
                print("Login Fail")
                
                LKProgressHUD.showFailure(text: "Facebook 登入錯誤！")
            }
        }
    }
    
    @IBAction func ghAppleLogin(_ sender: UIButton) {
    }
    
    @IBAction func ghLogin(_ sender: UIButton) {
    }
    
    func onGoHikingLogin(token: String) {
        
    }
    
    
}
