//
//  ChatTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/3/1.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()

        setElement()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setElement()
    }
    
    func setElement() {
        
        groupImage.layer.cornerRadius = 30
    }
    
}
