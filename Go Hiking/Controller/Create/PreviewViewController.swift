//
//  PreviewViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBAction func previewDismiss(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var previewDismiss: UIButton!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDesc: UILabel!
    
    @IBOutlet weak var eventStart: UILabel!
    
    @IBOutlet weak var eventEnd: UILabel!
    
    @IBOutlet weak var eventCancel: UIButton!
    
    @IBAction func eventCancel(_ sender: UIButton) {
        
    }
    
    var data: EventContent?
    
    func preSetUp() {
        
        guard let data = data else { return }
        
        eventTitle.text = data.title
        
        eventDesc.text = data.desc
        
        eventStart.text = data.start
        
        eventEnd.text = data.end
        
        eventImage.image = data.image
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preSetUp()
        // Do any additional setup after loading the view.
    }
    

}
