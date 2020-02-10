//
//  PreviewViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class PreviewViewController: UIViewController {

    @IBOutlet weak var preView: UIView!
    
    @IBOutlet weak var preTableView: UITableView!
    
    @IBAction func previewDismiss(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var previewDismiss: UIButton!
    
    @IBOutlet weak var eventCancel: UIButton!
    
    @IBAction func eventCancel(_ sender: UIButton) {
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setButton()
        
        setView()
        
        preTableView.rowHeight = UITableView.automaticDimension
        
        preTableView.delegate = self
        preTableView.dataSource = self
    }
    
    func setButton() {
        
        eventCancel.layer.cornerRadius = 25
        eventCancel.layer.shadowOffset = CGSize(width: 0, height: 3)
        eventCancel.layer.shadowOpacity = 0.7
        eventCancel.layer.shadowRadius = 5
        eventCancel.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    func setView() {
        
        preView.backgroundColor = .white
        preView.layer.cornerRadius = 15
        preView.layer.shadowOffset = CGSize(width: 0, height: 3)
        preView.layer.shadowOpacity = 0.7
        preView.layer.shadowRadius = 5
        preView.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    var data: EventContent?
    
}

extension PreviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PreContent", for: indexPath) as? PreContentTableViewCell else {
                return UITableViewCell()
        }
        
        cell.eventTitle.text = data?.title
        cell.eventDesc.text = data?.desc
        cell.eventTime.text = "\(data?.start ?? "") - \(data?.end ?? "")"
        cell.eventAmount.text = data?.amount
        cell.eventImage.image = data?.image
        
        return cell
    }

}
