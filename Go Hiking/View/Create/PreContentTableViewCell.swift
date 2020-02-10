//
//  PreContentTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class PreContentTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDesc: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var eventAmount: UILabel!
    
    func preSetUp(eventTitle: String, eventDesc: String, eventTime: String, eventAmount: String, eventImage: UIImage) {
                      
        self.eventTitle.text = eventTitle
           
        self.eventDesc.text = eventDesc
           
        self.eventTime.text = eventTime
           
        self.eventAmount.text = eventAmount
           
        self.eventImage.image = eventImage
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
