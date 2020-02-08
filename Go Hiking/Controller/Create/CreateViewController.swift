//
//  CreateViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class CreateViewController: UIViewController {
    
    let imagePickerController = UIImagePickerController()
    
    var nowDate = ""
    
    var nowAmount = ""
    
    var isStartDate = false
    
    var isEndDate = false
    
    var isAmount = false
    
    @IBOutlet weak var contentTableView: UITableView!
    
    func getNowDate() {
        
        let nowDate = Date()
        
        let timeInterval = TimeInterval(nowDate.timeIntervalSince1970)
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy年 mm月 dd日 EE"
        
        let today = dateFormatter.string(from: date)
        
        self.nowDate = today
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        contentTableView.rowHeight = UITableView.automaticDimension
        
        getNowDate()
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

extension CreateViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
            
        case 0:
            
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "Title", for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
            
            
            return titleCell
            
        case 1:
            
            guard let descCell = tableView.dequeueReusableCell(withIdentifier: "DESC", for: indexPath) as? DescTableViewCell else { return UITableViewCell() }
            
            
            return descCell
            
            
        case 2 :
            
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
            
            photoCell.delegate = self
            
            return photoCell
            
        case 3:
            
            guard let startDateCell = tableView.dequeueReusableCell(withIdentifier: "Start", for: indexPath) as? StartTableViewCell else { return UITableViewCell() }
            
            startDateCell.delegate = self
            startDateCell.setupDatePicker(isSelected: isStartDate, date: nowDate)
            
            return startDateCell
            
        case 4:
            
            guard let endDateCell = tableView.dequeueReusableCell(withIdentifier: "End", for: indexPath) as? EndTableViewCell else { return UITableViewCell() }
            
            endDateCell.delegate = self
            endDateCell.setupDatePicker(isSelected: isEndDate, date: nowDate)
            
            return endDateCell
            
        case 5:
            
            guard let personCell = tableView.dequeueReusableCell(withIdentifier: "Person", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
            
            personCell.delegate = self
            personCell.setupAmountPicker(isSelected: isAmount, amount: nowAmount)
            
            return personCell
            
        case 6:
            
            guard let personCell = tableView.dequeueReusableCell(withIdentifier: "Preview", for: indexPath) as? PreviewTableViewCell else { return UITableViewCell() }
            
            return personCell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            
            isStartDate = !isStartDate
            isEndDate = false
            isAmount = false
            
        } else if indexPath.row == 4 {
            
            isEndDate = !isEndDate
            isStartDate = false
            isAmount = false
            
        } else if indexPath.row == 5 {
            
            isAmount = !isAmount
            isStartDate = false
            isEndDate = false
        }
        contentTableView.reloadData()
    }
}

extension CreateViewController: PressToUploadPhoto {
    
    func presstoUploadPhoto(_ tableViewCell: PhotoTableViewCell) {
        
        alertAskForUpload()
    }
    
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        let uniqueString = NSUUID().uuidString
        
        if let selectedImage = selectedImageFromPicker {
            
            
            let storageRef = Storage.storage().reference().child("GHEventPhotoUpload").child("\(uniqueString).png")
            
            if let uploadData = selectedImage.pngData() {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                    
                    if error != nil {
                        
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        
                        guard let downloadURL = url else {
                            return
                        }
                        print(downloadURL)
                        
                    }
                })
            }
            
            
            print("\(uniqueString), \(selectedImage)")
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: StartDateisSelectedDelegate {
    
    func selectedStartDate(_ tableViewCell: StartTableViewCell, date: String) {
        
        self.nowDate = date
        
        contentTableView.reloadData()
    }
}

extension CreateViewController: EndDateisSelectedDelegate {
    
    func selectedEndDate(_ tableViewCell: EndTableViewCell, date: String) {
        
        self.nowDate = date
        
        contentTableView.reloadData()
    }
}

extension CreateViewController: PersonSelectedDelegate {
    
    func selectedPerson(_ tableViewCell: PersonTableViewCell, amount: String) {
        
        self.nowAmount = amount
        
        contentTableView.reloadData()
    }
}
