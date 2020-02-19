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
import GoogleSignIn
import Firebase
import FirebaseFirestore
import JGProgressHUD

class AuthViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var ghSignUp: UIButton!
    
    @IBOutlet weak var ghFacebookLogin: UIButton!
    
    @IBOutlet weak var ghAppleLogin: UIButton!
    
    @IBOutlet weak var ghGoogleSignIn: UIButton!
    
    func setNavVC() {
        
        let navBarNude = UIImage()
        navigationController?.navigationBar.setBackgroundImage(navBarNude, for: .default)
        self.navigationController?.navigationBar.shadowImage = navBarNude
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavVC()
        
        setButtonUI(button: ghSignUp)
        setButtonUI(button: ghFacebookLogin)
        setButtonUI(button: ghAppleLogin)
        setButtonUI(button: ghGoogleSignIn)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
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
                
                LKProgressHUD.showSuccess(text: "登入成功！", viewController: self)
                
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
                
                UserManager.share.signinUserData(credential: credential) { (result) in
                    
                    switch result {
                        
                    case .success:
                        
                        UserManager.share.loadUserInfo { result in
                            
                            switch result {
                                
                            case .success:
                                
                                print("ya")
                                
                            case .failure(let error):
                                
                                let fbLogin = error.localizedDescription.components(separatedBy: "noneLogin")
                                
                                if fbLogin.count > 1 {
                                    
                                    UserManager.share.saveUserData { result in
                                        
                                        switch result {
                                            
                                        case .success(let ya):
                                            print(ya)
                                            
                                        case .failure:
                                            
                                            print("error")
                                        }
                                    }
                                } else {
                                    print("error")
                                }
                            }
                        }
                    case .failure:
                        
                        LKProgressHUD.showFailure(text: "Facebook 登入錯誤！", viewController: self)
                    }
                }
                print("\(credential)")
                
                self.dismiss(animated: true, completion: nil)
            } else {
                print("No Login")
            }
        }
    }
    
    @IBAction func ghAppleLogin(_ sender: UIButton) {
    }
    
    @IBAction func ghGoogleSignIn(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func guestUser(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setButtonUI(button: UIButton) {
        
        button.layer.cornerRadius = 24
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 7
        button.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            
            UserManager.share.signinUserData(credential: credential) { (result) in
                switch result {
                    
                case .success:
                    
                    UserManager.share.loadUserInfo { result in
                        
                        switch result {
                            
                        case .success:
                            
                            print("Google Sign In Success")
                            
                        case .failure(let error):
                            
                            let googleLogin = error.localizedDescription.components(separatedBy: "noneLogin")
                            
                            if googleLogin.count > 1 {
                                
                                UserManager.share.saveUserData { result in
                                    
                                    switch result {
                                        
                                    case .success(let ya):
                                        print(ya)
                                        
                                    case .failure:
                                        
                                        print("error")
                                    }
                                }
                            } else {
                                
                                print("error")
                            }
                        }
                    }
                case .failure:
                    
                    LKProgressHUD.showFailure(text: "Google 登入錯誤！", viewController: self)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                
                self.dismiss(animated: true, completion: nil)
            }
            print("Success!!")
        }
    }
}
