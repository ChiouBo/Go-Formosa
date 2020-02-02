//
//  LoginViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/2.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import JGProgressHUD
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var userLoginEmail: UITextField!
    
    @IBOutlet weak var userLoginPassword: UITextField!
    
    @IBOutlet weak var userLoginBtn: UIButton!
    
    @IBAction func userLoginBtn(_ sender: UIButton) {
        
        if self.userLoginEmail.text == "" || self.userLoginPassword.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        } else {
            
            Auth.auth().signIn(withEmail: self.userLoginEmail.text!, password: self.userLoginPassword.text!) { (user, error) in
                
                if error == nil {
                    
                    LKProgressHUD.showSuccess(text: "登入成功！", viewController: self)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                } else {

                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButton()
        setLoginTextField(textField: userLoginEmail, placeholder: "  Email")
        setLoginTextField(textField: userLoginPassword, placeholder: "  Password")
        
    }
    
    func setLoginTextField(textField: UITextField, placeholder: String) {
        
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 25
        textField.layer.borderColor = UIColor.T3?.cgColor
        textField.placeholder = placeholder
    }
    
    func setButton() {
        
        userLoginBtn.layer.cornerRadius = 25
        userLoginBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        userLoginBtn.layer.shadowOpacity = 0.7
        userLoginBtn.layer.shadowRadius = 5
        userLoginBtn.layer.shadowColor = UIColor.lightGray.cgColor
    }

}
