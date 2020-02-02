//
//  SignUpViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/1.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    let userDB = Firestore.firestore()
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userConfirmPassword: UITextField!
    
    @IBOutlet weak var userSubmit: UIButton!
    
    @IBAction func userSubmit(_ sender: UIButton) {
        
        if let name = userName.text,
            let email = userEmail.text,
            let password = userPassword.text,
            let confirmpassword = userConfirmPassword.text,
            name != "",
            email != "",
            password != "",
            confirmpassword != "" {
            
            if userPassword.text != userConfirmPassword.text {
                
                let alertController = UIAlertController(title: "Error", message: "輸入的密碼不一致！", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                
            } else {
                
                Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { (user, error) in
                    
                    if error == nil {
                        
                        print("You have successfully signed up")
                        
                        self.addUserSignUpData()
                        
                        LKProgressHUD.showSuccess(text: "註冊成功！", viewController: self)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            
                            self.navigationController?.popViewController(animated: true)
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
    }
    
    let userID = Auth.auth().currentUser?.uid
    
    func addUserSignUpData() {
        
        guard let name = userName.text,
            let email = userEmail.text,
            let password = userPassword.text,
            let confirmpassword = userConfirmPassword.text else { return }
        
        userDB.collection("userEmail").document("\(userEmail.text!)").setData([
        
            "Name": name,
            "Email": email,
            "Password": password,
            "Confirm": confirmpassword,
            "ID": userID as Any
        ]) { (error) in
            
            if let error = error {
                
                print(error)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButton()
        
        setTextField(textField: userName, placeholder: "  Name")
        setTextField(textField: userEmail, placeholder: "  Email")
        setTextField(textField: userPassword, placeholder: "  Password")
        setTextField(textField: userConfirmPassword, placeholder: "  Confirm Password")
    }

    func setTextField(textField: UITextField, placeholder: String) {
        
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 25
        textField.layer.borderColor = UIColor.T3?.cgColor
        textField.placeholder = placeholder
    }
    
    func setButton() {
        
        userSubmit.layer.cornerRadius = 25
        userSubmit.layer.shadowOffset = CGSize(width: 0, height: 3)
        userSubmit.layer.shadowOpacity = 0.7
        userSubmit.layer.shadowRadius = 5
        userSubmit.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    

}
