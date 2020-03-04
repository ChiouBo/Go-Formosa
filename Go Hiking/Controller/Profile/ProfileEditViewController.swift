//
//  ProfileEditViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/16.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import FirebaseAuth
import KMPlaceholderTextView

protocol ProfileEditViewControllerDelegate: AnyObject {
    
    func infoEditedBacktoProfileVC(_ profileEditViewController: ProfileEditViewController,
                                   name: String, from: String, intro: String, cover: UIImage, picture: UIImage)
}

class ProfileEditViewController: UIViewController {
    
    
    var personPhoto = ""
    
    var backgroundImage = ""
    
    var isLibrary = false
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var editCancel: UIButton!
    
    @IBOutlet weak var editComplete: UIButton!
    
    @IBAction func editCancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editComplete(_ sender: UIButton) {
        
        
        guard let textName = editUserName.text,
            let textLocation = editUserFrom.text,
            let textIntro = editUserIntro.text,
            let id = Auth.auth().currentUser?.uid,
            let email = Auth.auth().currentUser?.email,
            let eventCreate = editUserInfo?.eventCreate,
            let event = editUserInfo?.event else { return }
        
        var isCover = false //如果背景沒圖 ＝ false
        var isPicture = false
        
        var cover = UIImage() // func外裝image
        var picture = UIImage()
        
        var coverData = Data() // func外裝pngData
        var pictureData = Data()
        
        if let coverTest = coverImage.image, let pictureTest = userImage.image {
            isCover = true
            isPicture = true
            cover = coverTest
            picture = pictureTest
            
            guard let coverD = coverTest.jpegData(compressionQuality: 0.5),
                  let pictureD = pictureTest.jpegData(compressionQuality: 0.5) else { return }
            
            coverData = coverD
            pictureData = pictureD
        } else if let coverTest = coverImage.image {
            isCover = true
            cover = coverTest
            guard let coverD = coverTest.jpegData(compressionQuality: 0.5) else { return }
                       coverData = coverD
                    
        } else if let pictureTest = userImage.image {
            
            if isLibrary {
                isPicture = true
                picture = pictureTest
                guard let pictureD = pictureTest.jpegData(compressionQuality: 0.5) else { return }
                           pictureData = pictureD
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let uniqueStringUser = NSUUID().uuidString
        let uniqueStringCover = NSUUID().uuidString
    
        let group = DispatchGroup()
        
        if isCover && isPicture {
            group.enter()
            group.enter()
        } else if isCover || isPicture {
            group.enter()
        } else { return  }
        
        if isPicture {
            UploadEvent.shared.storage(uniqueString: uniqueStringUser, data: pictureData) { (result) in
                
                switch result {
                    
                case .success(let userUpload):
                    
                    self.personPhoto = "\(userUpload)"
                    group.leave()
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        if isCover && isLibrary {
            
            UploadEvent.shared.storage(uniqueString: uniqueStringCover, data: coverData) { (result) in
                      
                      switch result {
                          
                      case .success(let userUpload):
                          
                          self.backgroundImage = "\(userUpload)"
                          group.leave()
                          
                      case .failure(let error):
                          print(error)
                      }
                  }
            
        } else { group.leave() }
        
        group.notify(queue: DispatchQueue.main) {
            
            let userInfo = UserInfo(id: id, name: textName, email: email, picture: self.personPhoto, introduction: textIntro, coverImage: self.backgroundImage, userLocation: textLocation, eventCreate: eventCreate, event: event)
            
            UserManager.share.uploadUserData(userInfo: userInfo) { result in
                
                switch result {
                    
                case .success(let success):
                    print(success)
                    NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                    
                    self.delegate?.infoEditedBacktoProfileVC(self, name: textName, from: textLocation, intro: textIntro, cover: cover, picture: picture)
                       
                    self.dismiss(animated: true, completion: nil)
                       
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func changeCover(_ sender: UIButton) {
        addUser = false
        addCover = true
        alertAskForUpload()
    }
    
    @IBAction func changeUserPhoto(_ sender: UIButton) {
        addUser = true
        addCover = false
        alertAskForUpload()
    }
    
    @IBOutlet weak var editUserName: GHTextField!
    
    @IBOutlet weak var editUserFrom: GHTextField!
    
    @IBOutlet weak var editUserIntro: KMPlaceholderTextView!
    
    weak var delegate: ProfileEditViewControllerDelegate?
    
    var editUserInfo: UserInfo?
    
    var addUser = false
    
    var addCover = false
    
    func setUserInfo() {
        
        editUserName.text = editUserInfo?.name
        userImage.loadImage(editUserInfo?.picture)
        coverImage.loadImage(editUserInfo?.coverImage)
        editUserFrom.text = editUserInfo?.userLocation
        editUserIntro.text = editUserInfo?.introduction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        setElements()
        setUserInfo()
        customizebackgroundView()
        coverImage.loadImage(backgroundImage, placeHolder: UIImage(named: "M001"))
    }
    
    func setElements() {
        
        userImage.layer.cornerRadius = 50
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.contentMode = .scaleAspectFill
        
        editUserName.layer.masksToBounds = true
        editUserName.layer.borderWidth = 1
        editUserName.layer.cornerRadius = 20
        editUserName.layer.borderColor = UIColor.gray.cgColor
        editUserName.contentMode = .scaleAspectFill
        
        editUserFrom.layer.masksToBounds = true
        editUserFrom.layer.borderWidth = 1
        editUserFrom.layer.cornerRadius = 20
        editUserFrom.layer.borderColor = UIColor.gray.cgColor
        
        editUserIntro.layer.masksToBounds = true
        editUserIntro.layer.borderWidth = 1
        editUserIntro.layer.cornerRadius = 5
        editUserIntro.layer.borderColor = UIColor.gray.cgColor
    }
    
    func customizebackgroundView() {
            
            let bottomColor = UIColor(red: 9/255, green: 32/255, blue: 63/255, alpha: 1)
            let topColor = UIColor(red: 59/255, green: 85/255, blue: 105/255, alpha: 1)
            let gradientColors = [bottomColor.cgColor, topColor.cgColor]
            
            let gradientLocations:[NSNumber] = [0.3, 1.0]
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = gradientColors
            gradientLayer.locations = gradientLocations
    //        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    //        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.frame = self.view.frame
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
    
    func alertAskForUpload() {
        
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                self.imagePickerController.sourceType = .photoLibrary
                
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                self.imagePickerController.sourceType = .camera
                
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        imagePickerAlertController.addAction(imageFromLibAction)
        
        imagePickerAlertController.addAction(imageFromCameraAction)
        
        imagePickerAlertController.addAction(cancelAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        isLibrary = true
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = pickedImage
            
            if addUser == true {
                
                userImage.image = selectedImageFromPicker
            } else {
                
                coverImage.image = selectedImageFromPicker
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
