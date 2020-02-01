//
//  SignUpViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/1.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userConfirmPassword: UITextField!
    
    @IBOutlet weak var userSubmit: UIButton!
    
    @IBAction func userSubmit(_ sender: UIButton) {
    }
    
    func setTextField() {
        
        userName.layer.masksToBounds = true
        userEmail.layer.masksToBounds = true
        userPassword.layer.masksToBounds = true
        userConfirmPassword.layer.masksToBounds = true
        
        userName.layer.borderWidth = 1
        userEmail.layer.borderWidth = 1
        userPassword.layer.borderWidth = 1
        userConfirmPassword.layer.borderWidth = 1
        
        userName.layer.cornerRadius = 25
        userEmail.layer.cornerRadius = 25
        userPassword.layer.cornerRadius = 25
        userConfirmPassword.layer.cornerRadius = 25
        
        userName.layer.borderColor = UIColor.T3?.cgColor
        userEmail.layer.borderColor = UIColor.T3?.cgColor
        userPassword.layer.borderColor = UIColor.T3?.cgColor
        userConfirmPassword.layer.borderColor = UIColor.T3?.cgColor
    }
    
    func setButton() {
        
        userSubmit.layer.cornerRadius = 24
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextField()
        
        setButton()
    }
    

    

}
