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
    
    var startDate = ""
    
    var endDate = ""
    
    var nowAmount = ""
    
    var counter = 0
    
    var isStartDate = false
    
    var isEndDate = false
    
    var isAmount = false
    
    var event = ""
    
    var desc = ""
    
    var photo: UIImage?
    
    var start = ""
    
    var end = ""
    
    var amount = ""
    
    var currentImageCount = 0
    
    var imageArray: [UIImage] = [] {
        
        didSet {
            contentTableView.reloadData()
        }
    }
    
    var trailEvent: TrailInfo?
    
    var trailCurrentImage: UIImage?
    
    var data: EventContent?
    
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBAction func eventCancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func eventPost(_ sender: UIButton) {
        
        let uniqueString = NSUUID().uuidString

        guard let uploadData = data?.image.pngData() else { return }

        LKProgressHUD.showWaitingList(text: "正在建立活動", viewController: self)

        UploadEvent.shared.storage(uniqueString: uniqueString, data: uploadData) { (result) in

            switch result {

            case .success(let upload):

                guard let data = self.data else { return }

                UploadEvent.shared.uploadEventData(evenContent: data, image: upload.absoluteString)

                LKProgressHUD.dismiss()

                LKProgressHUD.showSuccess(text: "開團成功！", viewController: self)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {

                    self.dismiss(animated: true, completion: nil)
                }

                print(upload)

            case .failure(let error):

                print(error)
            }
        }
    }
    
    func getStartDate() {
        
        let startDate = Date()
        
        let timeInterval = TimeInterval(startDate.timeIntervalSince1970)
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy年 MM月 dd日 EE"
        
        let today = dateFormatter.string(from: date)
        
        self.startDate = today
    }
    
    func getEndDate() {
        
        let endDate = Date()
        
        let timeInterval = TimeInterval(endDate.timeIntervalSince1970)
        
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy年 MM月 dd日 EE"
        
        let today = dateFormatter.string(from: date)
        
        self.endDate = today
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        contentTableView.rowHeight = UITableView.automaticDimension
        
        getStartDate()
        
        getEndDate()
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
            
            titleCell.delegate = self
            
            titleCell.titleTextField.text = trailEvent?.trailName
            
//            titleCell.eventCancel.addTarget(self, action: #selector(eventCancel), for: .touchUpInside)
            return titleCell
            
        case 1:
            
            guard let descCell = tableView.dequeueReusableCell(withIdentifier: "DESC", for: indexPath) as? DescTableViewCell else { return UITableViewCell() }
            
            descCell.delegate = self
            
            descCell.DescTextView.text = trailEvent?.trailDescrip
            
            return descCell
            
            
        case 2 :
            
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
            
            photoCell.delegate = self
            
            photoCell.photoArray = imageArray
            
            return photoCell
            
        case 3:
            
            guard let startDateCell = tableView.dequeueReusableCell(withIdentifier: "Start", for: indexPath) as? StartTableViewCell else { return UITableViewCell() }
            
            startDateCell.delegate = self
            startDateCell.setupDatePicker(isSelected: isStartDate, date: startDate)
            
            return startDateCell
            
        case 4:
            
            guard let endDateCell = tableView.dequeueReusableCell(withIdentifier: "End", for: indexPath) as? EndTableViewCell else { return UITableViewCell() }
            
            endDateCell.delegate = self
            endDateCell.setupDatePicker(isSelected: isEndDate, date: endDate)
            
            return endDateCell
            
        case 5:
            
            guard let personCell = tableView.dequeueReusableCell(withIdentifier: "Person", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
            
            personCell.delegate = self
            personCell.setupAmountPicker(counter: counter, isSelected: isAmount, amount: nowAmount)
            personCell.amountPickerView.delegate = self
            
            return personCell
            
        case 6:
            
            guard let previewCell = tableView.dequeueReusableCell(withIdentifier: "Preview", for: indexPath) as? PreviewTableViewCell else { return UITableViewCell() }
            
            previewCell.previewBtn.addTarget(self, action: #selector(passDatatoPreview), for: .touchUpInside)
            
            return previewCell
            
        default:
            return UITableViewCell()
        }
    }
    
//    @objc func eventCancel() {
//
//        dismiss(animated: true, completion: nil)
    //    }
    
    @objc func passDatatoPreview() {
        
        guard let previewVC = storyboard?.instantiateViewController(withIdentifier: "Preview") as? PreviewViewController,
            let photo =  photo else { return }
        
        if let info = trailEvent{
            
            let data = EventContent(image: photo, title: info.trailName, desc: info.trailDescrip, start: start, end: end, amount: nowAmount)
            previewVC.data = data
        } else {
            
            let data = EventContent(image: photo, title: event, desc: desc, start: start, end: end, amount: nowAmount)
            previewVC.data = data
        }
        
        previewVC.modalPresentationStyle = .overCurrentContext
        present(previewVC, animated: true, completion: nil)
        
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
            
            imageArray.append(pickedImage)
            
            currentImageCount = imageArray.count
        }
        
//        let uniqueString = NSUUID().uuidString
//
        if let selectedImage = selectedImageFromPicker {
//
            self.photo = selectedImage
//
//            let storageRef = Storage.storage().reference().child("GHEventPhotoUpload").child("\(uniqueString).png")
//
//            if let uploadData = selectedImage.pngData() {
//
//                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
//
//                    if error != nil {
//
//                        print("Error: \(error!.localizedDescription)")
//                        return
//                    }
//
//                    storageRef.downloadURL { (url, error) in
//
//                        guard let downloadURL = url else {
//                            return
//                        }
//                        print(downloadURL)
//                    }
//                })
//            }
//            print("\(uniqueString), \(selectedImage)")
        }
        contentTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: StartDateisSelectedDelegate {
    
    func selectedStartDate(_ tableViewCell: StartTableViewCell, date: String) {
        
        self.startDate = date
        
        self.start = date
        
        contentTableView.reloadData()
    }
}

extension CreateViewController: EndDateisSelectedDelegate {
    
    func selectedEndDate(_ tableViewCell: EndTableViewCell, date: String) {
        
        self.endDate = date
        
        self.end = date
        
        contentTableView.reloadData()
    }
}

extension CreateViewController: PersonSelectedDelegate {
    
    func didTap(_ tableViewCell: PersonTableViewCell) {
        
        self.counter += 1
        
        isAmount = !isAmount
        
        contentTableView.reloadData()
    }
    
    func selectedPerson(_ tableViewCell: PersonTableViewCell, amount: String) {
        
        self.nowAmount = amount
        
        self.amount = amount
        
        contentTableView.reloadData()
    }
}

extension CreateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 999
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(row+1) 人"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        nowAmount = "\(row+1) 人"
    }
}

extension CreateViewController: EventTitleisEdited, EventDESCisEdited {
    
    func titleIsEdited(_ tableViewCell: TitleTableViewCell, title: String) {
        
        self.event = title
    }
    
    func descIsEdited(_ tableViewCell: DescTableViewCell, desc: String) {
        
        self.desc = desc
    }
}
