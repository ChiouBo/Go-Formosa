//
//  ProfileEditViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/16.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ProfileEditViewController: UIViewController {

    @IBOutlet weak var editCancel: UIButton!
    
    @IBOutlet weak var editComplete: UIButton!
    
    @IBAction func editCancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editComplete(_ sender: UIButton) {
    }
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func changeCover(_ sender: UIButton) {
    }
    
    @IBAction func changeUserPhoto(_ sender: UIButton) {
    }
    
    @IBOutlet weak var editUserName: GHTextField!
    
    @IBOutlet weak var editUserFrom: GHTextField!
    
    @IBOutlet weak var editUserIntro: KMPlaceholderTextView!
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setElements()
        
    }
    
    func setElements() {
        
        userImage.layer.cornerRadius = 50
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.white.cgColor
        
        editUserName.layer.masksToBounds = true
        editUserName.layer.borderWidth = 1
        editUserName.layer.cornerRadius = 20
        editUserName.layer.borderColor = UIColor.gray.cgColor
        
        editUserFrom.layer.masksToBounds = true
        editUserFrom.layer.borderWidth = 1
        editUserFrom.layer.cornerRadius = 20
        editUserFrom.layer.borderColor = UIColor.gray.cgColor
        
        editUserIntro.layer.masksToBounds = true
        editUserIntro.layer.borderWidth = 1
        editUserIntro.layer.cornerRadius = 5
        editUserIntro.layer.borderColor = UIColor.gray.cgColor
    }


}
