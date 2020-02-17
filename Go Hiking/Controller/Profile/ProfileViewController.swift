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
    
    private enum contentType: Int {
        
        case history = 0
        
        case achievement = 1
        
        case level = 2
    }
    
    var userInfo: User?
    
    var userPic = ""
    var coverPic = ""
    
    @IBOutlet weak var userBackground: UIImageView!
    
    @IBOutlet weak var profileContent: UIView!
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userIntroduction: UILabel!
    
    //
    @IBAction func editUserInfo(_ sender: UIButton) {
        
        let editInfo = UIStoryboard(name: "Profile", bundle: nil)
        
        guard let editVC = editInfo.instantiateViewController(withIdentifier: "ProfileEdit") as? ProfileEditViewController else {
            return
        }
        
        let userProfileInfo = User(id: "",
                                   name: userName.text ?? "",
                                   email: "",
                                   picture: userPic,
                                   introduction: userIntroduction.text ?? "",
                                   coverImage: coverPic,
                                   userLocation: "")
        
        editVC.editUserInfo = userProfileInfo
        editVC.backgroundImage = userProfileInfo.coverImage!
        editVC.delegate = self
        editVC.modalPresentationStyle = .overCurrentContext
        present(editVC, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var indicator: UIView!
    
    @IBOutlet weak var indicatorConstaint: NSLayoutConstraint!
    
    @IBOutlet var contentChange: [UIButton]!
    
    @IBAction func toChangeContent(_ sender: UIButton) {
        
        for button in contentChange {
            
            button.isSelected = false
        }
        
        sender.isSelected = true
        
        moveIndicatorView(reference: sender)
        
        guard let type = contentType(rawValue: sender.tag) else { return }
        
        updateContainer(type: type)
    }
    
    var containerViews: [UIView] {
        
        return [userHistory, userAchievement, userLevel]
    }
    
    @IBOutlet weak var userHistory: UIView!
    
    @IBOutlet weak var userAchievement: UIView!
    
    @IBOutlet weak var userLevel: UIView!
    
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
    
    private func moveIndicatorView(reference: UIView) {
        
        self.view.layoutIfNeeded()
        
        indicatorConstaint.isActive = false
        
        indicatorConstaint = indicator.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
        
        indicatorConstaint.isActive = true
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
    
    private func updateContainer(type: contentType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .history:
            userHistory.isHidden = false
            contentChange[0].setTitleColor(.black, for: .normal)
            contentChange[1].setTitleColor(.lightGray, for: .normal)
            contentChange[2].setTitleColor(.lightGray, for: .normal)
            
        case .achievement:
            userAchievement.isHidden = false
            contentChange[0].setTitleColor(.lightGray, for: .normal)
            contentChange[1].setTitleColor(.black, for: .normal)
            contentChange[2].setTitleColor(.lightGray, for: .normal)
            
        case .level:
            userLevel.isHidden = false
            contentChange[0].setTitleColor(.lightGray, for: .normal)
            contentChange[1].setTitleColor(.lightGray, for: .normal)
            contentChange[2].setTitleColor(.black, for: .normal)
        }
    }
    
    func getUserInfo() {
        
        UserManager.share.loadUserInfo { (userInfo) in
            
            switch userInfo {
                
            case .success(let user):
                self.userName.text = user.name
                self.userPhoto.loadImage(user.picture)
                self.userPic = user.picture
                self.userBackground.loadImage(user.coverImage, placeHolder: UIImage(named: "M001"))
                guard let photo = user.coverImage else { return }
                self.coverPic = photo
                
            case .failure(let error):
                
                print(error)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reload"), object: nil)
        updateContainer(type: .achievement)
        setProfileUI()
        getUserInfo()
    }
    
    @objc func reload() {
        getUserInfo()
    }
    
    override func viewWillLayoutSubviews() {
        setProfileUI()
    }
    
    func setProfileUI() {
        
        profileContent.layer.cornerRadius = 500
        
        userPhoto.layer.cornerRadius = 50
        userPhoto.layer.borderWidth = 3
        userPhoto.layer.borderColor = UIColor.white.cgColor
        userPhoto.contentMode = .scaleAspectFill
    }
}

extension ProfileViewController: ProfileEditViewControllerDelegate {
    
    func infoEditedBacktoProfileVC(_ profileEditViewController: ProfileEditViewController,
                                   name: String, from: String, intro: String, cover: UIImage, picture: UIImage) {
        
        userName.text = name
        userIntroduction.text = intro
        userPhoto.image = picture
        userBackground.image = cover
        
    }
}
