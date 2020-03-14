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
import AuthenticationServices
import CryptoKit

class AuthViewController: UIViewController, GIDSignInDelegate {
    
    fileprivate var currentNonce: String?
    
    @IBOutlet weak var ghSignUp: UIButton!
    
    @IBOutlet weak var ghFacebookLogin: UIButton!
    
    @IBOutlet weak var ghGoogleSignIn: UIButton!
    
    @IBOutlet weak var ghAppleSignIn: UIView!
    
    func setNavVC() {
        
        let navBarNude = UIImage()
        navigationController?.navigationBar.setBackgroundImage(navBarNude, for: .default)
        self.navigationController?.navigationBar.shadowImage = navBarNude
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presentingViewController?.navigationController?.navigationBar.isHidden = true
        
        presentingViewController?.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        presentingViewController?.navigationController?.navigationBar.isHidden = false
        
        presentingViewController?.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavVC()
        
        if #available(iOS 13.0, *) {
            startSignInWithAppleFlow()
        }
        
        setButtonUI(button: ghSignUp)
        setButtonUI(button: ghFacebookLogin)
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
        
        manager.logOut()
        
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
                                
                                let fbLogin = error.localizedDescription.components(separatedBy: "FirebaseLogin error")
                                
                                if fbLogin.count > 1 {
                                    
                                    UserManager.share.saveUserData { result in
                                        
                                        switch result {
                                            
                                        case .success(let success):
                                            print(success)
                                            
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
        
        ghAppleSignIn.layer.cornerRadius = 24
        ghAppleSignIn.layer.shadowOffset = CGSize(width: 3, height: 3)
        ghAppleSignIn.layer.shadowOpacity = 0.7
        ghAppleSignIn.layer.shadowRadius = 7
        ghAppleSignIn.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        
        LKProgressHUD.showSuccess(text: "登入成功！", viewController: self)
        
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
                            
                            let googleLogin = error.localizedDescription.components(separatedBy: "FirebaseLogin error")
                            
                            if googleLogin.count > 1 {
                                
                                UserManager.share.saveUserData { result in
                                    
                                    switch result {
                                        
                                    case .success(let success):
                                        print(success)
                                        
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
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
        // swiftlint:disable syntactic_sugar
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    @available(iOS 13.0, *)
    func startSignInWithAppleFlow() {
        
            let appleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
            
            appleBtn.translatesAutoresizingMaskIntoConstraints = false
            appleBtn.addTarget(self, action: #selector(didTapAppleBtn), for: .touchUpInside)
            
            appleBtn.cornerRadius = 24
            
            appleBtn.frame = ghAppleSignIn.bounds
            
            ghAppleSignIn.addSubview(appleBtn)
            NSLayoutConstraint.activate([
                appleBtn.leadingAnchor.constraint(equalTo: ghAppleSignIn.leadingAnchor, constant: 0),
                appleBtn.trailingAnchor.constraint(equalTo: ghAppleSignIn.trailingAnchor, constant: 0),
                appleBtn.topAnchor.constraint(equalTo: ghAppleSignIn.topAnchor, constant: 0),
                appleBtn.bottomAnchor.constraint(equalTo: ghAppleSignIn.bottomAnchor, constant: 0)
            ])
      
    }
    
    @objc func didTapAppleBtn() {
        
        if #available(iOS 13.0, *) {
            
            let nonce = randomNonceString()
            currentNonce = nonce
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            controller.delegate = self
            
            controller.presentationContextProvider = self
            
            controller.performRequests()
        }
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
       
      return hashString
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // swiftlint:disable unused_closure_parameter control_statement
            Auth.auth().signIn(with: credential) { (authResult, error) in
        
                if (error != nil) {
                    
                    print(error?.localizedDescription)
                } else {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    return
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("Sign in with Apple errored: \(error)")
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return view.window!
    }
}
